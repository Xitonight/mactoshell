import Quickshell
import QtQuick.Layouts
import QtQuick
import "../theme"
import "../services"
import "modules"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWin
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent"

            implicitHeight: 36

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 12

                Rectangle {
                    radius: 6
                    color: Colors.surface
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: label.implicitWidth + 16
                    implicitHeight: label.implicitHeight + 8

                    Text {
                        id: label
                        anchors.centerIn: parent
                        text: "mactoshell"
                        color: Colors.text
                        font.bold: true
                        font.pointSize: 10
                    }
                }

                Workspaces {
                    panelWindow: panelWin
                    Layout.alignment: Qt.AlignVCenter
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    radius: 6
                    color: Colors.surface
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: clockText.implicitWidth + 16
                    implicitHeight: clockText.implicitHeight + 8

                    Text {
                        id: clockText
                        anchors.centerIn: parent
                        text: Time.time
                        color: Colors.subtext
                        font.pointSize: 10
                    }
                }

                Rectangle {
                    radius: 6
                    color: Colors.surface
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: modulesText.implicitWidth + 16
                    implicitHeight: modulesText.implicitHeight + 8

                    Text {
                        id: modulesText
                        anchors.centerIn: parent
                        text: "modules"
                        color: Colors.subtext
                        font.pointSize: 10
                    }
                }
            }
        }
    }
}
