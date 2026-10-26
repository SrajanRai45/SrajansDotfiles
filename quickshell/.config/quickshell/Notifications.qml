// Notifications.qml
// Drop-in notification daemon for Quickshell.
// Put this file next to shell.qml and use it as:  Notifications {}

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications

Scope {
    id: root

    // ───────────── config (override from shell.qml) ─────────────
    property int popupWidth: 380
    property int topMargin: 68          // clears your top bar
    property int rightMargin: 20
    property int spacing: 12
    property int defaultTimeout: 6000   // ms, for notifications with no timeout of their own
    property string fontFamily: "JetBrainsMono Nerd Font"
    property bool dnd: false            // do-not-disturb: drops everything except critical

    // ------- config for sounds---
    property bool soundEnabled: true
    property string soundPlayer: "paplay"   // or "pw-play"
    property string soundNormal: "/usr/share/sounds/freedesktop/stereo/message.oga"
    property string soundCritical: "/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"
    property string soundLow: ""            // empty = silent for low urgency

    readonly property alias server: server

    // ───────────── palette ─────────────
    // shell.qml passes these in from Theme; the defaults only matter as a fallback.
    property color bgColor: "#16161e"
    property color fgColor: "#c0caf5"
    property color dimColor: "#565f89"
    property color surfaceColor: "#292e42"
    property color accentColor: "#bb9af7"       // normal urgency
    property color accent2Color: "#7aa2f7"      // gradient end
    property color lowColor: "#7dcfff"          // low urgency
    property color criticalColor: "#f7768e"
    property color critical2Color: "#ff9e64"

    readonly property color cBgSolid: bgColor
    readonly property color cBg: Qt.alpha(bgColor, 0.94)
    readonly property color cFg: fgColor
    readonly property color cSub: Qt.alpha(fgColor, 0.70)
    readonly property color cDim: dimColor
    readonly property color cSurface: surfaceColor
    readonly property color cHover: Qt.alpha(fgColor, 0.15)
    readonly property color cTrack: Qt.alpha(fgColor, 0.12)
    readonly property color cNormal: accentColor
    readonly property color cNormal2: accent2Color
    readonly property color cLow: lowColor
    readonly property color cCritical: criticalColor
    readonly property color cCritical2: critical2Color

    // readable text colour on top of an accent
    function onColor(c) {
        const lum = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
        return lum > 0.55 ? "#101014" : "#ffffff";
    }

    function playSound(n) {
        if (!soundEnabled)
            return;
        const file = n.urgency === NotificationUrgency.Critical ? soundCritical : n.urgency === NotificationUrgency.Low ? soundLow : soundNormal;
        if (file !== "")
            Quickshell.execDetached([soundPlayer, file]);
    }
    // ───────────── the daemon itself ─────────────
    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: false
        imageSupported: true
        persistenceSupported: true

        onNotification: n => {
            if (root.dnd && n.urgency !== NotificationUrgency.Critical)
                return;          // not tracked -> dropped
            n.tracked = true;
            root.playSound(n);
        }
    }

    // qs ipc call notifications toggleDnd
    // qs ipc call notifications clear
    IpcHandler {
        target: "notifications"

        function toggleDnd(): void {
            root.dnd = !root.dnd;
        }

        function clear(): void {
            const all = server.trackedNotifications.values;
            for (let i = all.length - 1; i >= 0; i--)
                all[i].dismiss();
        }
    }

    // ───────────── popup window ─────────────
    PanelWindow {
        id: win

        anchors {
            top: true
            right: true
            bottom: true
        }
        implicitWidth: root.popupWidth + root.rightMargin
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "qs-notifications"

        // only the cards take clicks, everything else falls through
        mask: Region {
            item: list
        }

        ListView {
            id: list

            anchors {
                top: parent.top
                right: parent.right
                topMargin: root.topMargin
                rightMargin: root.rightMargin
            }
            width: root.popupWidth
            height: contentHeight
            spacing: root.spacing
            interactive: false
            model: server.trackedNotifications

            add: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 180
                    }
                    NumberAnimation {
                        property: "x"
                        from: list.width + root.rightMargin
                        to: 0
                        duration: 320
                        easing.type: Easing.OutCubic
                    }
                }
            }
            remove: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 150
                    }
                    NumberAnimation {
                        property: "x"
                        to: list.width + root.rightMargin
                        duration: 250
                        easing.type: Easing.InCubic
                    }
                }
            }
            displaced: Transition {
                NumberAnimation {
                    property: "y"
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }

            delegate: Item {
                id: card

                required property var modelData
                readonly property var n: modelData

                readonly property bool critical: n.urgency === NotificationUrgency.Critical
                readonly property color accent: critical ? root.cCritical : n.urgency === NotificationUrgency.Low ? root.cLow : root.cNormal
                readonly property color accent2: critical ? root.cCritical2 : root.cNormal2

                // notification timeout is in seconds; <= 0 means "not specified"
                readonly property int timeoutMs: {
                    if (n.expireTimeout > 0)
                        return n.expireTimeout * 1000;
                    return critical ? 0 : root.defaultTimeout;   // critical sticks until dismissed
                }

                readonly property var defaultAction: {
                    const a = n.actions;
                    for (let i = 0; i < a.length; i++)
                        if (a[i].identifier === "default")
                            return a[i];
                    return null;
                }
                readonly property bool hasActions: {
                    const a = n.actions;
                    for (let i = 0; i < a.length; i++)
                        if (a[i].identifier !== "default")
                            return true;
                    return false;
                }

                readonly property string iconSource: {
                    if (n.image)
                        return n.image;
                    const ic = n.appIcon;
                    if (ic) {
                        if (ic.startsWith("/"))
                            return "file://" + ic;
                        if (ic.indexOf(":/") > 0)
                            return ic;
                        return Quickshell.iconPath(ic, true);
                    }
                    if (n.desktopEntry)
                        return Quickshell.iconPath(n.desktopEntry, true);
                    return "";
                }

                property real progress: 1

                width: list.width
                height: content.implicitHeight + 28

                // countdown (pauses while hovered)
                NumberAnimation on progress {
                    running: card.timeoutMs > 0
                    paused: hover.hovered
                    from: 1
                    to: 0
                    duration: Math.max(card.timeoutMs, 1)
                    onFinished: card.n.expire()
                }

                HoverHandler {
                    id: hover
                }

                // gradient border
                Rectangle {
                    anchors.fill: parent
                    radius: 18
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {
                            position: 0
                            color: card.accent
                        }
                        GradientStop {
                            position: 1
                            color: card.accent2
                        }
                    }
                }
                // body
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1.5
                    radius: 16.5
                    color: root.cBg
                }

                // left click: default action (or dismiss) / right click: dismiss
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton && card.defaultAction)
                            card.defaultAction.invoke();
                        else
                            card.n.dismiss();
                    }
                }

                ColumnLayout {
                    id: content
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 14
                    }
                    spacing: 10

                    // header: app pill + close
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Rectangle {
                            implicitHeight: 20
                            implicitWidth: appName.implicitWidth + 18
                            radius: height / 2
                            color: card.accent

                            Text {
                                id: appName
                                anchors.centerIn: parent
                                text: card.n.appName || "notification"
                                color: root.onColor(card.accent)
                                font.family: root.fontFamily
                                font.pixelSize: 11
                                font.bold: true
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            Layout.preferredWidth: 22
                            Layout.preferredHeight: 22
                            radius: 11
                            color: closeMouse.containsMouse ? root.cHover : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                color: root.cDim
                                font.family: root.fontFamily
                                font.pixelSize: 11
                            }
                            MouseArea {
                                id: closeMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: card.n.dismiss()
                            }
                        }
                    }

                    // icon + text
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        ClippingRectangle {
                            visible: card.iconSource !== ""
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                            Layout.alignment: Qt.AlignTop
                            radius: 12
                            color: root.cSurface

                            Image {
                                anchors.fill: parent
                                source: card.iconSource
                                sourceSize: Qt.size(96, 96)
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                smooth: true
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            spacing: 3

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.n.summary
                                textFormat: Text.PlainText
                                color: root.cFg
                                font.family: root.fontFamily
                                font.pixelSize: 14
                                font.bold: true
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.n.body
                                textFormat: Text.StyledText
                                color: root.cSub
                                font.family: root.fontFamily
                                font.pixelSize: 12
                                wrapMode: Text.Wrap
                                maximumLineCount: 4
                                elide: Text.ElideRight
                                onLinkActivated: link => Qt.openUrlExternally(link)
                            }
                        }
                    }

                    // action buttons
                    RowLayout {
                        Layout.fillWidth: true
                        visible: card.hasActions
                        spacing: 6

                        Repeater {
                            model: card.n.actions

                            delegate: Rectangle {
                                id: btn
                                required property var modelData

                                visible: modelData.identifier !== "default"
                                implicitHeight: 26
                                implicitWidth: btnLabel.implicitWidth + 22
                                radius: height / 2
                                color: btnMouse.containsMouse ? card.accent : root.cSurface

                                Text {
                                    id: btnLabel
                                    anchors.centerIn: parent
                                    text: btn.modelData.text
                                    color: btnMouse.containsMouse ? root.onColor(card.accent) : root.cFg
                                    font.family: root.fontFamily
                                    font.pixelSize: 11
                                }
                                MouseArea {
                                    id: btnMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: btn.modelData.invoke()
                                }
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    // timeout bar
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 3
                        visible: card.timeoutMs > 0
                        radius: 1.5
                        color: root.cTrack

                        Rectangle {
                            width: parent.width * card.progress
                            height: parent.height
                            radius: parent.radius
                            color: card.accent
                        }
                    }
                }
            }
        }
    }
}
