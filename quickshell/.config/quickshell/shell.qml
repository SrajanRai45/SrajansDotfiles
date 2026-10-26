import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "theme"
import "Notifications"

ShellRoot {
    id: shell

    // ───────────── config ─────────────
    readonly property int barWidth: 44          // capsule width
    readonly property int edge: 6               // gap between capsules and the screen edge
    readonly property int gap: 6                // gap between capsules
    readonly property int flyoutSpace: 360      // transparent room to the right of the bar for hover labels
    readonly property int workspaceCount: 5
    readonly property var launcherCommand: []   // clicking the top icon runs this, e.g. ["fuzzel"]

    readonly property var powerActions: [
        {
            icon: "lock",
            tip: "Lock",
            color: Theme.blue,
            cmd: ["loginctl", "lock-session"]
        },
        {
            icon: "logout",
            tip: "Log out",
            color: Theme.yellow,
            cmd: ["hyprctl", "dispatch", "exit"]
        },
        {
            icon: "restart_alt",
            tip: "Restart",
            color: Theme.orange,
            cmd: ["systemctl", "reboot"]
        },
        {
            icon: "power_off",
            tip: "Shut down",
            color: Theme.red,
            cmd: ["systemctl", "poweroff"]
        }
    ]

    // notifications live once for the whole shell (not per monitor)
    Notifications {
        topMargin: 20

        bgColor: Theme.bgDark
        fgColor: Theme.fg
        dimColor: Theme.comment
        surfaceColor: Theme.bgHighlight
        accentColor: Theme.magenta
        accent2Color: Theme.blue
        lowColor: Theme.cyan
        criticalColor: Theme.red
        critical2Color: Theme.orange
    }

    // ───────────── shared state ─────────────
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // audio
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker {
        objects: shell.sink ? [shell.sink] : []
    }
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : true
    readonly property string volumeIcon: {
        if (muted || volume === 0)
            return "volume_off";
        if (volume < 0.34)
            return "volume_mute";
        if (volume < 0.67)
            return "volume_down";
        return "volume_up";
    }

    function setVolume(v) {
        if (sink && sink.audio)
            sink.audio.volume = Math.max(0, Math.min(1, v));
    }

    // hyprland
    function hasWorkspace(id) {
        const all = Hyprland.workspaces.values;
        for (let i = 0; i < all.length; i++)
            if (all[i].id === id)
                return true;
        return false;
    }

    readonly property string activeTitle: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""

    Scope {
        id: bluetoothChecker

        property bool isAdapterEnabled: Bluetooth.defaultAdapter ? Bluetooth.defaultAdapter.enabled : false

        // Filter the devices list to find ones where connected is true
        property var activeDevices: {
            if (!isAdapterEnabled || !Bluetooth.devices)
                return [];

            let connectedList = [];
            for (let i = 0; i < Bluetooth.devices.values.length; i++) {
                let dev = Bluetooth.devices.values[i];
                // Check if the device is actively connected
                if (dev.connected) {
                    connectedList.push(dev);
                }
            }
            return connectedList;
        }

        property bool hasConnectedDevices: activeDevices.length > 0

        property string primaryDeviceName: {
            if (!isAdapterEnabled)
                return "Off";
            if (!hasConnectedDevices)
                return "Nill";

            // Safely grab the name of the first truly connected device
            return activeDevices[0].name;
        }
    }

    Scope {
        id: wifiChecker

        // Find the wifi device and check if any network attached to it is connected
        property var activeWifiNetwork: {
            // Networking.devices contains all available network interfaces
            for (let i = 0; i < Networking.devices.values.length; i++) {
                let device = Networking.devices.values[i];
                // Check if it's a WiFi device and has networks
                if (device.type === DeviceType.Wifi && device.networks) {
                    for (let j = 0; j < device.networks.values.length; j++) {
                        let net = device.networks.values[j];
                        if (net.connected) {
                            return net; // Returns the connected WifiNetwork object
                        }
                    }
                }
            }
            return null;
        }

        // Convenience properties you can bind to your UI components
        property bool isConnected: activeWifiNetwork !== null
        property string networkName: isConnected ? activeWifiNetwork.name : "Disconnected"
    }

    Scope {
        id: iconProcessingForBattery
        property int batteryPercentage: Math.round(UPower.displayDevice.percentage * 100)
        property string icon: {
            if (UPower.onBattery) {
                if (batteryPercentage === 100) {
                    return "battery_android_full";
                } else if (batteryPercentage >= 70) {
                    return "battery_android_5";
                } else if (batteryPercentage >= 40) {
                    return "battery_android_4";
                } else if (batteryPercentage >= 20) {
                    return "battery_android_3";
                } else if (batteryPercentage > 10) {
                    return "battery_android_1";
                } else {
                    return "battery_android_alert";
                }
            } else {
                if (batteryPercentage === 100) {
                    return "battery_android_frame_bolt";
                } else if (batteryPercentage >= 70) {
                    return "battery_charging_80";
                } else if (batteryPercentage >= 40) {
                    return "battery_charging_60";
                } else if (batteryPercentage >= 20) {
                    return "battery_charging_30";
                } else {
                    return "battery_charging_full";
                }
            }
        }
    }

    readonly property color batteryColor: {
        const p = iconProcessingForBattery.batteryPercentage;
        if (!UPower.onBattery)
            return Theme.green;
        if (p <= 15)
            return Theme.red;
        if (p <= 30)
            return Theme.orange;
        return Theme.green;
    }

    // ───────────── the sidebar (one per monitor) ─────────────
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData
            screen: modelData

            anchors {
                top: true
                bottom: true
                left: true
            }
            // wide on purpose: the extra width is only used to draw hover flyouts
            implicitWidth: shell.edge * 2 + shell.barWidth + shell.flyoutSpace
            color: "transparent"

            // tiled windows only reserve the bar itself, not the flyout space
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: shell.edge * 2 + shell.barWidth
            WlrLayershell.namespace: "qs-bar"

            // only the bar strip takes input; everything else clicks through
            mask: Region {
                item: strip
            }

            Item {
                id: strip
                width: shell.edge * 2 + shell.barWidth
                height: parent.height

                ColumnLayout {
                    anchors {
                        fill: parent
                        margins: shell.edge
                    }
                    spacing: shell.gap

                    // ── workspaces ──
                    Pill {
                        Layout.fillWidth: true

                        Item {
                            id: wsBox

                            readonly property int cell: 30
                            readonly property int activeId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1

                            implicitWidth: 36
                            implicitHeight: shell.workspaceCount * cell

                            // sliding highlight
                            Rectangle {
                                visible: wsBox.activeId >= 1 && wsBox.activeId <= shell.workspaceCount
                                x: 4
                                y: (wsBox.activeId - 1) * wsBox.cell + 1
                                width: 28
                                height: 28
                                radius: 14
                                color: Theme.magenta

                                Behavior on y {
                                    NumberAnimation {
                                        duration: 220
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }

                            Column {
                                Repeater {
                                    model: shell.workspaceCount

                                    delegate: Item {
                                        id: ws
                                        required property int index
                                        readonly property int wsId: index + 1
                                        readonly property bool active: wsBox.activeId === wsId
                                        readonly property bool occupied: shell.hasWorkspace(wsId)

                                        width: 36
                                        height: wsBox.cell

                                        Text {
                                            anchors.centerIn: parent
                                            text: ws.wsId
                                            font.family: "JetBrains Mono"
                                            font.pixelSize: 14
                                            font.bold: ws.active
                                            color: ws.active ? Theme.bgDark : ws.occupied ? Theme.fg : Theme.comment
                                            Behavior on color {
                                                ColorAnimation {
                                                    duration: 150
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse => {
                                    const id = Math.floor(mouse.y / wsBox.cell) + 1;
                                    if (id >= 1 && id <= shell.workspaceCount)
                                        Hyprland.dispatch("workspace " + id);
                                }
                                onWheel: wheel => Hyprland.dispatch(wheel.angleDelta.y > 0 ? "workspace e-1" : "workspace e+1")
                            }
                        }
                    }

                    // ── active window title (rotated), uses whatever space is left ──
                    Item {
                        id: winWrap
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Pill {
                            id: winPill
                            visible: shell.activeTitle !== "" && winWrap.height > 90
                            width: parent.width
                            height: Math.min(titleText.implicitWidth + 32, winWrap.height)
                            clip: true

                            Item {
                                id: winBox
                                implicitWidth: 36
                                implicitHeight: Math.max(0, winPill.height - winPill.padding * 2)

                                Text {
                                    id: titleText
                                    text: shell.activeTitle
                                    width: Math.max(0, winBox.height - 24)
                                    rotation: 90
                                    transformOrigin: Item.TopLeft
                                    x: (winBox.width + height) / 2
                                    y: 12
                                    elide: Text.ElideRight
                                    color: Theme.fgDark
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 13
                                }
                            }
                        }
                    }

                    // ── system tray ──
                    Pill {
                        Layout.fillWidth: true
                        visible: SystemTray.items.values.length > 0

                        Repeater {
                            model: SystemTray.items

                            delegate: BarIcon {
                                id: trayItem
                                required property var modelData

                                tip: modelData.tooltipTitle || modelData.title || modelData.id

                                IconImage {
                                    anchors.centerIn: parent
                                    width: 20
                                    height: 20
                                    source: trayItem.modelData.icon
                                }

                                onClicked: mouse => {
                                    const it = trayItem.modelData;
                                    if (mouse.button === Qt.MiddleButton) {
                                        it.secondaryActivate();
                                    } else if (mouse.button === Qt.LeftButton && !it.onlyMenu) {
                                        it.activate();
                                    } else if (it.hasMenu) {
                                        const p = trayItem.mapToItem(null, trayItem.width, 0);
                                        it.display(bar, p.x, p.y);
                                    }
                                }
                            }
                        }
                    }

                    // ── clock ──
                    Pill {
                        Layout.fillWidth: true

                        BarIcon {
                            implicitHeight: 62
                            tip: Qt.formatDateTime(clock.date, "dddd, d MMMM yyyy")

                            Column {
                                id: clockCol
                                anchors.centerIn: parent
                                width: parent.width
                                spacing: 0

                                Text {
                                    width: clockCol.width
                                    horizontalAlignment: Text.AlignHCenter
                                    text: Qt.formatDateTime(clock.date, "hh AP").split(" ")[0]
                                    color: Theme.fg
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                                Text {
                                    width: clockCol.width
                                    horizontalAlignment: Text.AlignHCenter
                                    text: Qt.formatDateTime(clock.date, "mm")
                                    color: Theme.fg
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                                Text {
                                    width: clockCol.width
                                    horizontalAlignment: Text.AlignHCenter
                                    text: Qt.formatDateTime(clock.date, "AP")
                                    color: Theme.yellow
                                    font.family: "JetBrains Mono"
                                    font.pixelSize: 10
                                }
                            }
                        }
                    }

                    // ── status ──
                    Pill {
                        Layout.fillWidth: true

                        BarIcon {
                            icon: wifiChecker.isConnected ? "wifi" : "wifi_off"
                            iconColor: wifiChecker.isConnected ? Theme.blue : Theme.comment
                            tip: wifiChecker.networkName
                        }
                        BarIcon {
                            icon: bluetoothChecker.isAdapterEnabled ? "bluetooth" : "bluetooth_disabled"
                            iconColor: bluetoothChecker.isAdapterEnabled ? Theme.cyan : Theme.comment
                            tip: bluetoothChecker.primaryDeviceName
                        }
                        BarIcon {
                            icon: shell.volumeIcon
                            iconColor: shell.muted ? Theme.comment : Theme.magenta
                            tip: shell.muted ? "Muted" : Math.round(shell.volume * 100) + "%"
                            // click = mute, scroll = volume
                            onClicked: mouse => {
                                if (shell.sink && shell.sink.audio)
                                    shell.sink.audio.muted = !shell.sink.audio.muted;
                            }
                            onScrolled: event => shell.setVolume(shell.volume + (event.angleDelta.y > 0 ? 0.02 : -0.02))
                        }
                        BarIcon {
                            icon: iconProcessingForBattery.icon
                            iconColor: shell.batteryColor
                            tip: iconProcessingForBattery.batteryPercentage + "%  " + (UPower.onBattery ? "On battery" : "Plugged in")
                        }
                    }

                    // ── power (click to expand, collapses when you leave it) ──
                    Pill {
                        id: powerPill
                        Layout.fillWidth: true

                        property bool open: false

                        HoverHandler {
                            id: powerHover
                        }
                        Timer {
                            interval: 1200
                            running: powerPill.open && !powerHover.hovered
                            onTriggered: powerPill.open = false
                        }

                        // options grow upward out of the power button; the rest of the
                        // bar is pushed up smoothly because the window pill above absorbs the change
                        Item {
                            id: optsBox

                            readonly property real full: shell.powerActions.length * 34
                            readonly property real target: powerPill.open ? full : 0

                            implicitWidth: 36
                            implicitHeight: target
                            visible: implicitHeight > 0.5
                            opacity: full > 0 ? implicitHeight / full : 0
                            // only clip while animating, so hover labels still show once settled
                            clip: implicitHeight !== target

                            Behavior on implicitHeight {
                                NumberAnimation {
                                    duration: 280
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Column {
                                anchors.bottom: parent.bottom

                                Repeater {
                                    model: shell.powerActions

                                    delegate: BarIcon {
                                        id: powerOption
                                        required property var modelData

                                        icon: modelData.icon
                                        iconColor: modelData.color
                                        tip: modelData.tip
                                        onClicked: mouse => {
                                            Quickshell.execDetached(powerOption.modelData.cmd);
                                            powerPill.open = false;
                                        }
                                    }
                                }
                            }
                        }

                        BarIcon {
                            icon: "power_settings_new"
                            iconColor: Theme.red
                            tip: powerPill.open ? "" : "Power"
                            onClicked: mouse => powerPill.open = !powerPill.open
                        }
                    }
                }
            }
        }
    }
}
