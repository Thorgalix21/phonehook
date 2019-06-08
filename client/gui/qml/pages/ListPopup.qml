import QtQuick 2.5
import Sailfish.Silica 1.0

MouseArea {
    id: rootArea
    property QtObject popoverModel: model
    property var itemSelectorIndex: parent.itemSelectorIndex
    anchors.fill: parent
    onClicked: popoverModel.reject()

    property var contentArea

    Component.onCompleted: {
        rootArea.parent = contentArea
        //list.positionViewAtIndex(itemSelectorIndex, ListView.Center)

    }

    Rectangle {
        anchors.fill: parent
        color: "#33000000"
    }

    /*ListView {
        id: list
        anchors.centerIn: parent
        width: Math.min(parent.width*.8, parent.height*.8)
        model: popoverModel.items
        height: Math.min(contentHeight, parent.height*.8)

        delegate: BackgroundItem {
            width: parent.width
            enabled: model.enabled
            Rectangle {
                anchors.fill: parent
                color: Qt.darker(Theme.highlightColor, .3)
            }

            TextSwitch {
                anchors.left: parent.left
                anchors.leftMargin: 20
                id: lbl
                text: model.text
                checked: model.selected
                onClicked: {
                    rootArea.parent.itemSelectorIndex = model.index;
                    popoverModel.accept(model.index);
                }
            }

        }

    }*/


    Item {
        id: container

        width:  rect.width  + (2 * rectShadow.radius);
        height: rect.height + (2 * rectShadow.radius);

        x: {
            if (popoverModel.elementRect.x + width/2 > rootArea.width) {
                rootArea.width - popoverModel.elementRect.x - Theme.paddingMedium
            } else if (popoverModel.elementRect.x - width + popoverListView.contentItem.width/2 < 0) {
                30
            } else {
                rootArea.width / 2 - width / 2
            }
        }

        y: {
            if (popoverModel.elementRect.y + popoverModel.elementRect.height + height < rootArea.height ) {
                popoverDownCaret.visible = true
                popoverUpCaret.visible = false
                popoverModel.elementRect.y + popoverModel.elementRect.height
            } else {
                popoverDownCaret.visible = false
                popoverUpCaret.visible = true
                popoverModel.elementRect.y - height
            }
        }

        Rectangle {
            id: rect
            width: rootArea.width / 2
            height: rootArea.height / 2.5 //( popoverListView.contentItem.height < 300 ) ? popoverListView.contentItem.height + 40 : 300
            radius: 5
            anchors.centerIn: parent
            antialiasing: true;
            color: "black"

            Text {
                id: popoverUpCaret
                anchors { left: parent.horizontalCenter; margins: -Theme.paddingSmall; top: parent.bottom; }
                text: "\uF0D7"
                color: "gray"
                font.pixelSize: Theme.fontSizeMedium
            }
            Text {
                id: popoverDownCaret
                anchors { left: parent.horizontalCenter; margins: -Theme.paddingSmall; top: parent.top; topMargin: -Theme.paddingSmall*5; }
                text: "\uF0D8"
                color: "gray"
                font.pixelSize: Theme.fontSizeMedium
            }

            ListView {
                id: popoverListView
                anchors { fill: parent; margins: Theme.paddingSmall ; topMargin: Theme.paddingMedium; bottomMargin: Theme.paddingMedium }
                model: popoverModel.items
                clip: true

                delegate: Rectangle {
                    color: "transparent"
                    height: Theme.itemSizeSmall
                    width: parent.width
                    radius: 5

                    BackgroundItem {
                        anchors.fill: parent
                        enabled: model.enabled

                        Text {
                            anchors { left: parent.left; leftMargin: Theme.paddingSmall; right: parent.right; rightMargin: Theme.paddingSmall; verticalCenter: parent.verticalCenter }
                            text: model.text
                            color: model.selected ? Theme.highlightColor : "white"
                            font { pixelSize: Theme.fontSizeSmall }
                            elide: Text.ElideRight
                        }

                        Text { // highlight
                            visible: model.selected ? true : false
                            anchors.verticalCenter: parent.verticalCenter
                            color: Theme.highlightColor; text: "\uF00C";
                            anchors.right : parent.right
                            font.pixelSize: Theme.fontSizeMedium
                            font.weight: Font.Bold
                        }
                        onClicked: { rootArea.parent.itemSelectorIndex = model.index ; popoverModel.accept(model.index); }
                    }
                }
                Component.onCompleted: {
                    // console.debug("[PopOver.qml] Created ListView with index at:" + itemSelectorIndex)
                    positionViewAtIndex(itemSelectorIndex, ListView.Beginning);
                }
            }
        }
    }
}
