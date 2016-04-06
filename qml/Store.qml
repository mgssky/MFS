import QtQuick 2.0
import VPlayPlugins.googleanalytics 1.0

Rectangle {
  id: shop
  width: (gameScene.width/2)+(gameScene.width/2)/2
  height: ((gameScene.height/2)+(gameScene.height/2)/2)+50
  color: "#E89376"
  border.width: 5
  border.color: "white"
  radius: 15
  anchors.centerIn: parent
  property bool isOpen: false

  gradient: Gradient {
          GradientStop { position: 1.0; color: "#11AC93"}
          GradientStop { position: 0.0; color: "#30796D"}
        }
  //opacity: 0.95
  Column {
    anchors.fill: parent
    scale: 0.98
    spacing: -2
    Rectangle {
      width: parent.width
      height: parent.width/4
      color: "transparent"
      Text {
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 28
        text: "Training Room"
      }

    }

    StoreCluster {
      width: parent.width
      height: 45
      rText: "Common"
      suitName: "common"
      price: 0
    }
    StoreCluster {
      width: parent.width
      height: 45
      rText: "White Belt"
      suitName: "white"
      price: 10
    }
    StoreCluster {
      width: parent.width
      height: 45
      rText: "Blue Belt"
      suitName: "blue"
      price: 25
    }
    StoreCluster {
      width: parent.width
      height: 45
      rText: "Red Belt"
      suitName: "red"
      price: 50
    }
    StoreCluster {
      width: parent.width
      height: 45
      rText: "Black Belt"
      suitName: "black"
      price: 100
    }
    StoreCluster {
      width: parent.width
      height: 45
      rText: "Ninja"
      suitName: "ninja"
      price: 200
    }
    StoreCluster {
      width: parent.width
      height: 45
      rText: "Senpai"
      suitName: "senpai"
      price: 500
    }
  }
  Rectangle {
    width: 48
    height: 48
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    color: "#41E144"
    anchors.leftMargin: -16
    anchors.bottomMargin: -16
    //anchors.verticalCenterOffset: 24
    radius: 25

    Image {
      anchors.centerIn: parent
      width: parent.width-10
      height: parent.height-10
      source: "../assets/gui/agree.png"
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        if(coins >= selectedCluster.price && !selectedCluster.open) {
          coins = coins - selectedCluster.price
          settings.setValue("coins", coins)
          settings.setValue(selectedCluster.suitName, true)
          selectedCluster.open = true
          ga.logEvent("Buy", selectedCluster.suitName)

        }
        else {
          // no money message
        }

        if(settings.getValue(selectedCluster.suitName)) {
          settings.setValue("lastSuit", selectedCluster.suitName)
          ga.logEvent("Select", selectedCluster.suitName)
          coinSound.play()
        }


      }
    }
  }
  Rectangle {
    width: 48
    height: 48
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    color: "#E1221E"
    anchors.rightMargin: -16
    anchors.bottomMargin: -16
    //anchors.verticalCenterOffset: 24
    radius: 25

    Image {
      anchors.centerIn: parent
      width: parent.width-10
      height: parent.height-10
      source: "../assets/gui/cancel.png"
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
       close()
      }
    }
  }
  SequentialAnimation {
    id: storeClosingAnimation
    NumberAnimation {
      targets: shop
      property: "scale"
      from: 1
      to: 0
      duration: 250
      running: false
      easing.type: Easing.OutExpo
    }
    ScriptAction {
      script: {
        shop.visible = false
        shop.isOpen = false
      }
    }
  }
  SequentialAnimation {
    id: storeOpeningAnimation

    ScriptAction {
      script: {
        shop.visible = true
        shop.isOpen = true
      }
    }
    NumberAnimation {
      targets: shop
      property: "scale"
      from: 0.2
      to: 1
      duration: 500
      running: false
      easing.type: Easing.OutExpo
    }
  }
  function open() {
    storeOpeningAnimation.start()
  }
  function close() {
    storeClosingAnimation.start()
  }
}

