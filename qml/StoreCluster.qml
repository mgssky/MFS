import QtQuick 2.0

Rectangle {
  id: storeClusterID
  property string suitName
  property int price: 0
  property bool open: settings.getValue(suitName)
  property string rText: ""
  property color rColor: "black"

  color: "transparent"
  radius: 15
  border.color: "white"
  border.width: 3
  opacity: 0.7

  gradient: Gradient {
          GradientStop { position: 1.0; color:  open ? "#0F9233" : "#D5F4EB"}
          GradientStop { position: 0.0; color: open ? "#00DF3D" :"#A69BA8"}
        }

  MouseArea {
    anchors.fill: parent
    onClicked:  {
      selectedCluster = storeClusterID
      //if(selectedCluster === settings.getValue("lastSuit"))
        //console.log(selectedCluster.suitName === settings.getValue("lastSuit"))
    }
  }


  Rectangle {
    id: iconRect
    anchors.left: parent.left
    //anchors.horizontalCenter: parent.horizontalCenter
    color: "transparent"
    width: parent.height
    height: parent.height
    radius: 15
    border.color: "white"
    border.width: 3
    opacity: 0.7

    Image {
      source: "../assets/gui/" + suitName + ".png"
      width: 40
      height: 40
      anchors.centerIn: parent
    }


  }

  Rectangle {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: iconRect.right
    height: parent.height/2
    radius: 2
    color: "transparent"
//    border.color: "white"
//    border.width: 2

    Text {
      color: "black"
      font.pixelSize: 16
      text: rText
      anchors.right: parent.right
      anchors.rightMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      //anchors.centerIn: parent
      //anchors.horizontalCenterOffset: 50

    }
  }
  Rectangle {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: iconRect.right
    height: parent.height/2
    radius: 2
    color: "transparent"
//    border.color: "white"
//    border.width: 2

    Image {
      source: "../assets/gui/coin.png"
      width: 16
      height: 16
      anchors.right: priceText.left
      anchors.rightMargin: 0
      anchors.verticalCenter: parent.verticalCenter
      visible: !open || price != 0
    }

    Text {
      id: priceText
      color: "black"
      font.pixelSize: 16
      text: price
      anchors.right: parent.right
      anchors.rightMargin: 6
      anchors.verticalCenter: parent.verticalCenter
      visible: !open || price != 0

    }
  }
  Rectangle {
    anchors.fill: parent
    color: "transparent"
    radius: 15
    border.color: "yellow"
    border.width: 5
    visible: selectedCluster === storeClusterID
  }
}
