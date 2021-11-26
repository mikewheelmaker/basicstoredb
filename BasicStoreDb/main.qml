import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import QtQml 2.0
import QtQuick.Controls.Material 2.0

Window {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("BasicStoreDb")

    property int itemIndex: -1

    Dialog {
        id: confirmDeleteItemDialog

        title: "Delete item?"
        width: 200
        height: 150
        anchors.centerIn: parent

        ColumnLayout {
            id: deleteDialogWindowContainer

            anchors.fill: parent

            RowLayout {
                id: deleteItemOptionsContainer

                Layout.fillWidth: true

                Button {
                    id: deleteItemDialogAcceptButton

                    text: "Yes"
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onClicked: {
                        ApplicationManager.removeItem(itemIndex)
                        itemIndex = -1
                        confirmDeleteItemDialog.accept()
                    }
                }

                Button {
                    id: deleteItemDialogCancelButton

                    text: "No"
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onClicked: confirmDeleteItemDialog.close()
                }
            }
        }
    }

    Dialog {
        id: addItemDialog

        title: "Add item"
        width: 400
        height: 150
        anchors.centerIn: parent

        ColumnLayout {
            id: addItemDialogWindowContainer

            anchors.fill: parent

            RowLayout {
                id: addItemInputContainer

                Layout.fillWidth: true

                TextField {
                    id: newItemName

                    Layout.fillWidth: true
                    Layout.preferredHeight: 30

                    placeholderText: qsTr("Item Name")
                }

                TextField {
                    id: newItemRegNumber

                    Layout.fillWidth: true
                    Layout.preferredHeight: 30

                    placeholderText: qsTr("Registration Number")
                }
            }

            RowLayout {
                id: addItemOptionsContainer

                Layout.fillWidth: true

                Button {
                    id: addItemDialogAcceptButton

                    text: "Add item"
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onClicked: {
                        ApplicationManager.addItem(newItemName.text, newItemRegNumber.text)
                        addItemDialog.accept()
                    }
                }

                Button {
                    id: addItemDialogCancelButton

                    text: "Cancel"
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onClicked: addItemDialog.close()
                }
            }
        }
    }

    Component {
        id: itemDelegate

        Rectangle {
            id: itemDelegateContainer
            width: mainWindow.width - 10
            height: 40
            color: "transparent"

            MouseArea {
                id: itemSelectionArea

                width: itemDelegateContainer.width
                height: itemDelegateContainer.height

                onDoubleClicked: {
                    itemIndex = index
                    confirmDeleteItemDialog.open()
                }
            }

            RowLayout {
                id: itemLayoutContainer
                width: itemDelegateContainer.width
                height: itemDelegateContainer.height

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
            }
        }
    }

    ColumnLayout {
        id: mainContainer

        anchors.fill: parent

        spacing: 0

        Rectangle {
            id: menuBackgroundRectangle

            Layout.preferredHeight: 50
            Layout.fillWidth: true

            color: "#A9A9A9"

            RowLayout {
                id: menuContainer

                anchors.fill: parent

                Button {
                    id: addItemButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 110

                    text: "Add item"

                    onClicked: addItemDialog.open()
                }

                Button {
                    id: exportDataButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Export"

                    onClicked: ApplicationManager.exportDB()
                }

                Button {
                    id: clearDataButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Clear"

                    onClicked: ApplicationManager.clearDB()
                }

                Rectangle {
                    id: paddingRectangle

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    color: menuBackgroundRectangle.color
                }

                Button {
                    id: exitButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 100

                    text: "Exit"

                    onClicked: close()
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

                    onTextChanged: ApplicationManager.searchProxy(0, inputItemName.text.toUpperCase())

                    //onEditingFinished: inputItemName.text = ""
                }

                Button {
                    id: nameAscSortButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 20

                    text: "^"

                    onClicked: ApplicationManager.sortProxy(0, true)
                }

                Button {
                    id: nameDescSortButton

                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 20

                    text: "v"

                    onClicked: ApplicationManager.sortProxy(0, false)
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
                //reuseItems: true
                cacheBuffer: 20

                onFlickEnded: gc()

                model: ApplicationManager.itemProxyModel
                delegate: itemDelegate
            }
        }
    }
}
