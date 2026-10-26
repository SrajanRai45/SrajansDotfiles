import Quickshell
import QtQuick

PanelWindow {
    anchors {
        left: true
        top: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Normal
    implicitWidth: 30
    implicitHeight: 20
    color: "transparent"
    MouseArea {
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.left: parent.left
        onClicked: {}
    }
}
