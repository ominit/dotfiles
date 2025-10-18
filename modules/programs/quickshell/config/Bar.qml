import Quickshell
import Quickshell.Services.UPower
import QtQuick

Scope {
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            required property var modelData
            screen: modelData
            
            color: "#100e23"
            anchors {
                top: true
                left: true
                bottom: true
            }

            implicitWidth: 40

            ClockWidget {
                color: "#cbe3e7"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    // bottom: parent.bottom
                    // bottomMargin: 15
                    top: parent.top
                    topMargin: 15
                }
            }

            Text {
                text: Math.trunc(UPower.displayDevice.percentage * 100) + "%"
                color: "#cbe3e7"
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    // bottom: parent.bottom
                    // bottomMargin: 140
                    top: parent.top
                    topMargin: 140
                }
            }
        }
    }
}
