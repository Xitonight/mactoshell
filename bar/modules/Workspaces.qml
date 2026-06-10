import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland._Ipc
import "../../theme"

Item {
    id: root

    required property var panelWindow

    readonly property var monitor: Hyprland.monitorFor(panelWindow.screen)
    readonly property var activeWorkspace: monitor ? monitor.activeWorkspace : null
    readonly property int activeWorkspaceId: activeWorkspace ? activeWorkspace.id : 0

    readonly property int totalWorkspaces: 10
    readonly property int buttonSize: 28
    readonly property int dotSize: 6
    readonly property int padding: 6
    readonly property int animDuration: 200

    property var occupiedMap: ({})
    property int prevActiveId: activeWorkspaceId

    function updateOccupied() {
        var map = {};
        var wsList = Hyprland.workspaces.values || [];
        for (var i = 0; i < wsList.length; i++) {
            var ws = wsList[i];
            if (ws && ws.id !== undefined) {
                var tlCount = ws.toplevels ? ws.toplevels.count : 0;
                if (tlCount > 0) {
                    map[ws.id] = true;
                }
            }
        }
        occupiedMap = map;
    }

    implicitWidth: totalWorkspaces * buttonSize + padding * 2
    implicitHeight: buttonSize + padding * 2

    Rectangle {
        anchors.fill: parent
        radius: 6
        color: Colors.surface
    }

    onActiveWorkspaceIdChanged: {
        prevActiveId = activeWorkspaceId;
    }

    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            root.updateOccupied();
        }
    }

    Connections {
        target: Hyprland.toplevels
        function onValuesChanged() {
            root.updateOccupied();
        }
    }

    Component.onCompleted: updateOccupied()

    WheelHandler {
        onWheel: event => {
            if (event.angleDelta.y < 0)
                Hyprland.dispatch("hl.dsp.focus({ workspace = \"r+1\" })");
            else if (event.angleDelta.y > 0)
                Hyprland.dispatch("hl.dsp.focus({ workspace = \"r-1\" })");
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    Row {
        anchors.fill: parent
        anchors.margins: padding
        spacing: 0

        Repeater {
            model: root.totalWorkspaces

            Item {
                required property int index
                readonly property int wsId: index + 1
                readonly property bool isActive: root.activeWorkspaceId === wsId
                readonly property bool isOccupied: root.occupiedMap[wsId] === true

                width: root.buttonSize
                height: root.buttonSize

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + wsId)
                    cursorShape: Qt.PointingHandCursor
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: root.dotSize
                    height: root.dotSize
                    radius: width / 2
                    color: isActive ? Colors.accent : (isOccupied ? Colors.text : Colors.subtext)
                    opacity: isActive ? 1.0 : (isOccupied ? 0.8 : 0.35)

                    Behavior on color {
                        enabled: root.animDuration > 0
                        ColorAnimation {
                            duration: root.animDuration
                            easing.type: Easing.OutQuad
                        }
                    }

                    Behavior on opacity {
                        enabled: root.animDuration > 0
                        NumberAnimation {
                            duration: root.animDuration
                            easing.type: Easing.OutQuad
                        }
                    }

                    Behavior on width {
                        enabled: root.animDuration > 0
                        NumberAnimation {
                            duration: root.animDuration
                            easing.type: Easing.OutSine
                        }
                    }

                    Behavior on height {
                        enabled: root.animDuration > 0
                        NumberAnimation {
                            duration: root.animDuration
                            easing.type: Easing.OutSine
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: activePill
        z: -1

        property int targetIndex: root.activeWorkspaceId - 1
        property real idx1: targetIndex
        property real idx2: targetIndex

        width: Math.abs(idx1 - idx2) * root.buttonSize + root.dotSize + 8
        height: root.dotSize + 8
        radius: height / 2
        color: Colors.accent
        opacity: 0.15

        anchors.verticalCenter: parent.verticalCenter

        x: padding + Math.min(idx1, idx2) * root.buttonSize + root.buttonSize / 2 - width / 2

        Behavior on idx1 {
            enabled: root.animDuration > 0
            NumberAnimation {
                duration: root.animDuration / 3
                easing.type: Easing.OutSine
            }
        }

        Behavior on idx2 {
            enabled: root.animDuration > 0
            NumberAnimation {
                duration: root.animDuration
                easing.type: Easing.OutSine
            }
        }

        Behavior on opacity {
            enabled: root.animDuration > 0
            NumberAnimation {
                duration: root.animDuration
                easing.type: Easing.OutQuad
            }
        }
    }
}
