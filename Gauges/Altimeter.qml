import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string name:                  "altitude (100m)"
    property string dialimagesource:       "speed10.png"
    property string shorthandimagesource:  "shorthand.png"
    property string longhandimagesource:   "longhand.png"
    property string secondhandimagesource: "secondhand.png"
    property int divider: 100
    property int digits: 2

    property list<QtObject> sources: [
        Item { property string name: "Current Altitude";  property double source: altitudemodel.current },
        Item { property string name: "Average Altitude";  property double source: altitudemodel.average },
        Item { property string name: "Minimum Altitude";  property double source: altitudemodel.minimum },
        Item { property string name: "Maximum Altitude";  property double source: altitudemodel.maximum },
        Item { property string name: "Total Ascent";      property double source: altitudemodel.ascent  },
        Item { property string name: "Total Descent";     property double source: altitudemodel.descent }
    ]

    property list<QtObject> targets: [
        Item { id: analog; property string name: "Analog";  property int mode: 0; property double value: sources[mode].source },
        Item { id: top;    property string name: "Top";     property int mode: 1; property double value: sources[mode].source },
        Item { id: bottom; property string name: "Bottom";  property int mode: 2; property double value: sources[mode].source }
    ]

    function toFixed(num,count) {
        var s = num.toFixed(count).toString();
        return s;
    }

    property Item optiontabs: TabLayout {
        id: tablayout

        TabItem {
            title: "Analog"
        }
        TabItem {
            title: "Digital Top"
        }
        TabItem {
            title: "Digital Bottom"
        }
    }

    Image {
        source: root.dialimagesource
        anchors.fill: parent

        Text {
            id: nametext
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.3
            text: root.name;
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3* 0.18
            style: Text.Raised; styleColor: "black"
        }
    }

    Rectangle {
        y: parent.height * 0.75
        height: parent.height * 0.16
        color: "black"
        width: parent.width/4
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(top.value/root.divider,root.digits)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(bottom.value/root.divider,root.digits)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
    }

    Image {
        source: root.shorthandimagesource
        anchors.fill: parent
        transform: Rotation {
            id: shorthand
            origin.x: width/2
            origin.y: height/2
            angle: -180 + analog.value/(100*root.divider) * 360
            Behavior on angle {
                id: shorthandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }

    Image {
        source: root.longhandimagesource
        anchors.fill: parent
        transform: Rotation {
            id: longhand
            origin.x: width/2
            origin.y: height/2
            angle: -180 + analog.value/(10*root.divider) * 360
            Behavior on angle {
                id: longhandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }

    Image {
        source: root.secondhandimagesource
        anchors.fill: parent
        transform: Rotation {
            id: secondhand
            origin.x: width/2
            origin.y: height/2
            angle: -180 + analog.value/root.divider * 360
            Behavior on angle {
                id: secondhandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }
}
