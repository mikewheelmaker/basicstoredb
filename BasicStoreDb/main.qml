import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQml

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("BasicStoreDb")

    Component {
        id: itemDelegate

        RowLayout {
            id: itemLayoutContainer

            width: parent.width
            height: 40

            Text {
                id: itemName

                text: name
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                font.pointSize: 20
            }

            Text {
                id: itemRegNumber

                text: regNumber
                font.pointSize: 20
            }

            Button {
                id: deleteItem

                Layout.preferredHeight: 20
                Layout.preferredWidth: 20
                Layout.alignment: Qt.AlignRight

                text: "X"

                onClicked: {
                    ApplicationManager.removeItem(index);
                }
            }
        }
    }

    ColumnLayout {
        id: mainContainer

        anchors.fill: parent

        spacing: 2

        Rectangle {
            id: menuBackgroundRectangle

            Layout.preferredHeight: 50
            Layout.fillWidth: true

            color: "#A9A9A9"

            RowLayout {
                id: menuContainer

                anchors.fill: parent

                Button {
                    id: importDataButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Import"

                    onClicked: {
                        //import data from csv into db
                        ApplicationManager.importDB();
                    }
                }

                Button {
                    id: exportDataButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Export"

                    onClicked: {
                        //export data from db into csv
                        ApplicationManager.exportDB();
                    }
                }

                Button {
                    id: clearDataButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Clear"

                    onClicked: {
                        // clear data from DB
                        ApplicationManager.clearDB();
                    }
                }

                Rectangle {
                    id: paddingRectangle

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    color: menuBackgroundRectangle.color
                }

                Button {
                    id: helpButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Help"

                    onClicked: {
                        //open help window
                    }
                }

                Button {
                    id: exitButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Exit"

                    onClicked: {
                        //safely close application
                        close();
                    }
                }
            }
        }

        Rectangle {
            id: searchBarBackgroundRectangle

            Layout.preferredHeight: 50
            Layout.fillWidth: true

            color: "#C0C0C0"

            RowLayout {
                id: searchBarContainer

                anchors.fill: parent

                TextField {
                    id: inputItemName

                    Layout.fillWidth: true

                    placeholderText: qsTr("Enter item name here")

                    onTextChanged: {
                        //update proxy model
                        ApplicationManager.searchProxy(0, inputItemName.text)
                    }

                    onEditingFinished: inputItemName.text = ""
                }

                Button {
                    id: nameAscSortButton

                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20

                    text: "^"

                    onClicked: {
                        //set proxy search direction as ascending
                        ApplicationManager.sortProxy(0, true)
                    }
                }

                Button {
                    id: nameDescSortButton

                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20

                    text: "v"

                    onClicked: {
                        //set proxy search direction as descending
                        ApplicationManager.sortProxy(0, false)
                    }
                }
            }
        }

        Rectangle {
            id: listViewBackgroundRectangle

            Layout.fillHeight: true
            Layout.fillWidth: true

            color: "#DCDCDC"

            ListView {
                id: itemList

                anchors.fill: parent
                anchors.leftMargin: 5
                anchors.rightMargin: 5

                clip: true

                model: ApplicationManager.itemProxyModel
                delegate: itemDelegate
            }
        }
    }
}
