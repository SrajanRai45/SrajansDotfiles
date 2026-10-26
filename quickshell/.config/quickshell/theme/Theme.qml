pragma Singleton

import QtQuick 6.10
import Quickshell
import Quickshell.Io
import "../config.js" as Config

// Live palette backed by pywal16 (installed via `uv tool install pywal16`).
//
// Reads ~/.cache/wal/colors.json (written by `wal -i <img>` / `wal -R`) and
// hot-reloads whenever it changes, so running `wal` recolors the shell with
// no quickshell restart. Falls back to the Tokyo Night palette in config.js
// until the file loads or if it is missing/corrupt.
Singleton {
    id: root

    // Tokyo Night fallback palette (config.js)
    readonly property var fallback: Config.tokyoNight

    // Raw pywal16 payload: { wallpaper, alpha, special: {...}, colors: {color0..color15} }
    property var wal: ({})
    readonly property var colors: wal.colors ?? ({})
    readonly property var special: wal.special ?? ({})

    readonly property bool loaded: wal.colors !== undefined
    readonly property string wallpaper: wal.wallpaper ?? ""

    // === Backgrounds & surfaces ===
    readonly property color bg: colors.color0 ?? fallback.bg
    readonly property color bgDark: colors.color0 ? Qt.darker(colors.color0, 1.3) : fallback.bgDark
    readonly property color bgHighlight: colors.color0 ? Qt.lighter(colors.color0, 1.4) : fallback.bgHighlight

    // === Text ===
    readonly property color fg: special.foreground ?? colors.color7 ?? fallback.fg
    readonly property color fgDark: Qt.darker(fg, 1.25)

    // === Muted chrome ===
    readonly property color terminalBlack: colors.color8 ?? fallback.terminalBlack
    readonly property color fgGutter: colors.color8 ? Qt.darker(colors.color8, 1.5) : fallback.fgGutter
    readonly property color comment: colors.color8 ?? fallback.comment
    readonly property color selection: colors.color0 ? Qt.lighter(colors.color0, 1.7) : fallback.selection

    // === Core accents (pywal16: 1=red 2=green 3=yellow 4=blue 5=magenta 6=cyan) ===
    readonly property color red: colors.color1 ?? fallback.red
    readonly property color redDark: colors.color1 ? Qt.darker(colors.color1, 1.35) : fallback.redDark
    readonly property color orange: colors.color3 ? Qt.lighter(colors.color3, 1.12) : fallback.orange
    readonly property color yellow: colors.color3 ?? fallback.yellow
    readonly property color green: colors.color2 ?? fallback.green
    readonly property color greenCyan: colors.color2 ? Qt.lighter(colors.color2, 1.2) : fallback.greenCyan
    readonly property color cyan: colors.color6 ?? fallback.cyan
    readonly property color blue: colors.color4 ?? fallback.blue
    readonly property color blueDark: colors.color4 ? Qt.darker(colors.color4, 1.4) : fallback.blueDark
    readonly property color blueLight: colors.color4 ? Qt.lighter(colors.color4, 1.3) : fallback.blueLight
    readonly property color magenta: colors.color5 ?? fallback.magenta
    readonly property color purple: colors.color5 ? Qt.darker(colors.color5, 1.25) : fallback.purple

    // === Git / status ===
    readonly property color gitAdd: colors.color2 ?? fallback.gitAdd
    readonly property color gitChange: colors.color4 ?? fallback.gitChange
    readonly property color gitDelete: colors.color1 ?? fallback.gitDelete

    // === Diagnostics ===
    readonly property color error: colors.color1 ?? fallback.error
    readonly property color warning: colors.color3 ?? fallback.warning
    readonly property color info: colors.color4 ?? fallback.info
    readonly property color hint: colors.color6 ?? fallback.hint

    // pywal may rewrite colors.json while we read it; retry a few times before
    // giving up and staying on the previous/fallback palette.
    property int parseRetries: 0

    function loadColors(text: string): void {
        try {
            const data = JSON.parse(text);
            if (!data || typeof data !== "object" || !data.colors)
                throw new Error("missing colors section");
            wal = data;
            parseRetries = 0;
            console.log("[Theme] pywal16 palette loaded:", wallpaper);
        } catch (e) {
            const msg = e && e.message ? e.message : e;
            if (parseRetries < 5) {
                parseRetries++;
                console.warn("[Theme] colors.json not ready, retry " + parseRetries + ": " + msg);
                retryTimer.restart();
            } else {
                console.error("[Theme] colors.json unreadable, keeping fallback palette: " + msg);
            }
        }
    }

    Timer {
        id: retryTimer
        interval: 120
        onTriggered: walFile.reload()
    }

    FileView {
        id: walFile
        path: Quickshell.env("HOME") + "/.cache/wal/colors.json"
        preload: true
        watchChanges: true
        // watchChanges only emits fileChanged(); reload() re-reads the file and
        // then emits loaded() with the fresh text.
        onFileChanged: reload()
        onLoaded: root.loadColors(text())
        onLoadFailed: err => {
            if (err !== FileViewError.FileNotFound)
                console.warn("[Theme] colors.json read failed: " + FileViewError.toString(err));
        }
    }
}
