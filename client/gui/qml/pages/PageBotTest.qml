import QtQuick 2.5
import Sailfish.Silica 1.0

Page {
    id: root

    property string name
    property int botId

    PageHeader {
        title: name
    }

    Column {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge

        Item {
            width: parent.width
            height: Screen.height * 0.2
        }

        TextField {
            id: testNumber
            width: parent.width
            placeholderText: qsTr("Phone Number")
            anchors.horizontalCenter: parent.horizontalCenter
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter

            text: qsTr("Run")
            enabled: testNumber.text.length > 0

            onClicked: {
                _bots.testBot(botId, testNumber.text);
            }
        }
    }
}
