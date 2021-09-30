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

    ListModel {
        id: itemsModel
        ListElement { name: "Product #1"; regNumber: "0001" }
        ListElement { name: "Product #2"; regNumber: "0002" }
        ListElement { name: "Product #3"; regNumber: "0003" }
    }

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
                    //prompt delete dialog
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
                    }
                }

                Button {
                    id: exportDataButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Export"

                    onClicked: {
                        //export data from db into csv
                    }
                }

                Button {
                    id: clearDataButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Clear"

                    onClicked: {
                        //clear all data from db
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
                    }
                }

                Button {
                    id: nameDescSortButton

                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20

                    text: "v"

                    onClicked: {
                        //set proxy search direction as descending
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

                model: itemsModel
                delegate: itemDelegate
            }
        }
    }
}
