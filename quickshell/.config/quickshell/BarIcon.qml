import QtQuick
import "theme"

// One cell inside a Pill: an icon, a hover highlight, and a flyout label that
// slides out to the right of the bar while hovered.
//
//   BarIcon {
//       icon: "wifi"
//       tip: "Airtel_sraj_1979"
//       onClicked: mouse => console.log(mouse.button)
//   }
//
// Anything declared inside BarIcon {} is drawn on top of the icon area, so you
// can use it for custom content (see the clock in shell.qml).
Item {
    id: root

    property string icon: ""
    property string tip: ""                 // flyout text, empty = no flyout
    property color iconColor: Theme.blue
    property int iconSize: 20
    readonly property bool hovered: area.containsMouse

    default property alias content: extra.data

    signal clicked(var mouse)
    signal scrolled(var event)

    implicitWidth: 36
    implicitHeight: 34

    // hover highlight
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Qt.alpha(Theme.selection, root.hovered ? 1 : 0)
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Text {
        anchors.centerIn: parent
        visible: root.icon !== ""
        text: root.icon
        color: root.iconColor
        font.family: "Material Symbols Rounded"
        font.pixelSize: root.iconSize
    }

    Item {
        id: extra
        anchors.fill: parent
    }

    // flyout: purely visual, it never takes input
    Rectangle {
        id: flyout

        visible: opacity > 0
        opacity: root.hovered && root.tip !== "" ? 1 : 0
        x: root.width + 12 - (1 - opacity) * 8
        anchors.verticalCenter: parent.verticalCenter
        width: label.width + 28
        height: 34
        radius: height / 2
        color: Theme.bgDark
        border.width: 1
        border.color: Theme.bgHighlight

        Behavior on opacity { NumberAnimation { duration: 140 } }

        Text {
            id: label
            anchors.centerIn: parent
            width: Math.min(implicitWidth, 290)
            text: root.tip
            color: Theme.fg
            elide: Text.ElideRight
            font.family: "JetBrains Mono"
            font.pixelSize: 14
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: mouse => root.clicked(mouse)
        onWheel: wheel => root.scrolled(wheel)
    }
}
