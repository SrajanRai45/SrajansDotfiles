import QtQuick
import QtQuick.Layouts
import "theme"

// A vertical capsule that stacks whatever you put inside it.
//
//   Pill {
//       BarIcon { icon: "wifi" }
//       BarIcon { icon: "bluetooth" }
//   }
Rectangle {
    id: root

    default property alias content: col.data
    property int padding: 4
    property int spacing: 0

    implicitWidth: 44
    implicitHeight: col.implicitHeight + padding * 2
    radius: width / 2
    color: Theme.bgDark
    border.width: 1
    border.color: Theme.bgHighlight

    ColumnLayout {
        id: col
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.padding
        spacing: root.spacing
    }
}
