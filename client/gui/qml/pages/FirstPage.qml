/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: topPage

    property variant remorseItem

    function remorseDelete() {
        remorseDeleteBot.execute(remorseItem,
                                 "Deleting " + remorseItem.name,
                                 function() {
                                     console.log('do delete', remorseItem.id);
                                     _bots.removeBot(remorseItem.id);
                                 }, 5000);
    }

    function colorAlpha(c, alpha) {
        return Qt.rgba(c.r, c.g, c.b, alpha);
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height+header.height+50

        PageHeader {
            id: header
            title: qsTr("Phonehook")
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
        }


        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            enabled: _bots.daemonActive
/*
            MenuItem {
                text: qsTr("Number Test")
                onClicked: {
                    onClicked: pageStack.push(Qt.resolvedUrl("PageBotTest.qml"), { name: "Bot Test", botId: 0});
                }
            }
*/

            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    onClicked: pageStack.push(Qt.resolvedUrl("PageAppSettings.qml"))
                }
            }

        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: topPage.width
            spacing: Theme.paddingLarge
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: header.bottom

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: Theme.paddingLarge

                ControlBigButton {
                    link: "PageServerBotList.qml"
                    icon: "../images/website-optimization-48.png"
                    text: qsTr("Data Sources")
                }

                ControlBigButton {
                    link: "PageSearchStart.qml"
                    icon: "../images/search-2-48.png"
                    text: qsTr("Search")
                }

            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: Theme.paddingLarge



                ControlBigButton {
                    link: "PageBlockStart.qml"
                    icon: "../images/restriction-shield-48.png"
                    text: qsTr("Blocks")
                }

                ControlBigButton {
                    link: "PageCallLogStart.qml"
                    icon: "../images/view-details-48.png"
                    text: qsTr("Call Log")
                }

            }



            Text {
                id: hi
                color: "#FFFFFF"
                wrapMode: Text.Wrap
                textFormat: Text.RichText
                text: qsTr("Daemon") + ": <b>" + (_bots.daemonActive ? qsTr("Running") : qsTr("Not Running")) + "</b>"
            }

            Button {
                visible: !_bots.daemonActive
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Start Daemon")

                onClicked: {
                    _bots.startDaemon();
                }
            }

            Item {
                height: 20
                width: parent.width
            }

            Label {
                width: parent.width
                text: qsTr("Installed Sources")
                font.weight: Font.Bold
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
            }

            Label {
                //: No installed sources
                text: qsTr("None")
                visible: botView.model.count === 0
            }

            RemorseItem {
                id: remorseDeleteBot
            }

            Connections {
                target: _bots
                onDaemonActiveChanged: {
                    console.log('daemon active!');
                }
            }

            SilicaListView {
                id: botView
                model: _bots.daemonActive ? _bots.botList : []

                height: (contentHeight || 0) + 100
                anchors.left: parent.left
                anchors.right: parent.right

                anchors.leftMargin: -Theme.paddingLarge
                anchors.rightMargin: -Theme.paddingLarge

                interactive: false
                enabled: _bots.daemonActive

                property Item contextMenu

                delegate: Item {
                    id: myListItem
                    property bool menuOpen: botView.contextMenu != null && botView.contextMenu.parent === myListItem
                    property int id: model.id
                    property string name: model.name

                    width: ListView.view.width
                    height: menuOpen ? botView.contextMenu.height + contentItem.height : contentItem.height


                    BackgroundItem {
                        id: contentItem

                        Label {
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.paddingLarge
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.name
                            color: contentItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        }

                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: Theme.paddingLarge
                            text: 'Rev. ' + model.revision
                            font.pixelSize: Theme.fontSizeSmall
                            color: contentItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        }

                        onPressAndHold: {
                            remorseItem = myListItem;
                            if (!botView.contextMenu)
                                botView.contextMenu = contextMenuComponent.createObject(botView)
                            botView.contextMenu.show(myListItem)
                        }

                        onClicked: {
                            remorseItem = myListItem;
                            pageStack.push(Qt.resolvedUrl("PageBotDetails.qml"), { botId: model.id })
                            console.log("clicked on bot")
                        }
                    }
                }
                Component {
                    id: contextMenuComponent
                    ContextMenu {
                           MenuItem {
                            text: qsTr("Delete");
                            onClicked: {
                                remorseDelete();
                            }
                        }
                    }
                }
            }
        }
    }
}


