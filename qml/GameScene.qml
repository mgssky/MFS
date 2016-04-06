import VPlay 2.0
import QtQuick 2.0

import VPlayPlugins.admob 1.0
import VPlayPlugins.chartboost 1.1
import VPlayPlugins.googleanalytics 1.0



SceneBase {
  id:gameScene

  // signal indicating that the gameScene should be displayed
  signal menuScenePressed

  state: "tutorial"

  property var lastPillar: pil3

  function refreshFrogg() {
    frog.refreshFrog()
    frog.revive()
  }
  function showAd() {
    showAdNum++
    if(showAdNum > 4) {
      interstitial.loadInterstitial()
      showAdNum = 0
    }
  }
  AdMobInterstitial {
       id: interstitial

       adUnitId: "ca-app-pub-2641450699078558/5448079224"

       onInterstitialReceived: {
         showInterstitialIfLoaded()
       }

//       onInterstitialFailedToReceive: {
//         console.debug("Interstitial not loaded")
//       }
     }

  MultiResolutionImage {
    anchors.centerIn: gameScene.gameWindowAnchorItem
    source: "../assets/bg.png"
    MouseArea {
      id: mouseArea
      anchors.fill: parent
      enabled: gameScene.state !== "tutorial"
      onClicked: frog.move()
    }
  }

  AdMobBanner {
       adUnitId: "ca-app-pub-2641450699078558/7064413225"
       banner: AdMobBanner.Smart
       anchors.horizontalCenter: parent.Center
       visible: settings.getValue("showAds")
     }

  Rectangle {
    color: "white"
    radius: 15
    width: 300
    height: 300
    anchors.centerIn: parent
    border.width: 5
    border.color: "green"
    opacity: 0.8
    z: 2
    visible: gameScene.state === "tutorial"

    MultiResolutionImage {
      id: tutorial
      source: "../assets/tutorial.png"
      anchors.fill: parent
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        gameScene.state = "ready"
      }
    }
  }



  PhysicsWorld {
    id: physcs
    debugDrawVisible: false // turn it on for debugging
    updatesPerSecondForPhysics: 60
    gravity.y: 50 // how much gravity do you want?
  }

  Pillar {
    id: pil1
//    x: gameScene.width/2
//    y: 330
  }
  Pillar {
    id: pil2
//    x: (gameScene.width/2)+250+(200*Math.random())
//    y: 330
  }
  Pillar {
    id: pil3
//    x: (gameScene.width/2)+550+(200*Math.random())
//    y: 330
  }

  Frog {
    id: frog
    x: ((gameScene.width/2)+frog.width/2)
    y: 200
  }

  Border {
    x: 0
    y: gameScene.height+100
  }

  SpecialEffect {
    id: sp
    x: gameScene.width/2
    y: 100
  }

  Fly {
    id: gameFly
    x: 550
    y: 90
    Component.onCompleted: {
      gameFly.die()
    }
  }

  Rectangle {
    id: scoreTable
    width: parent.width/4
    height: parent.width/8
    visible: !gameOverTable.visible
    color: "black"
    opacity: 0.7
    radius: 10
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: -190
    Text {
      color: "white"
      font.pixelSize: 32
      anchors.centerIn: parent
      text: score
    }
  }

  Row {
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    Image {
      width: 32
      height: 32
      source: "../assets/gui/coin.png"
    }
    Text {
      text: coins
      font.pixelSize: 24
      color: "white"
    }
  }
  Rectangle {
    color: "black"
    width: 40
    height: 40
    opacity: 0.8
    radius: 10
    anchors.right: parent.right
    visible: !gameOverTable.visible
    anchors.bottom: parent.bottom
    Image {
      anchors.fill: parent
      source: "../assets/gui/menu.png"
      scale: 0.7
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        gameOverTable.visible = false
        frog.revive()
        gameWindow.state = "menu"
      }
    }
  }

  Rectangle {
    id: gameOverTable
    color: "black"
    radius: 15
    anchors.centerIn: parent
    width: (parent.width/2)+parent.width/4
    height: (parent.height/2)
    visible: false
    opacity: 0.9

    Column {
      spacing: 2
      anchors.fill: parent
      Rectangle {
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        width: (parent.width/2)
        height: (parent.height/6)
        radius: 15
        opacity: 0.9
        Text {
          anchors.centerIn: parent
          font.pixelSize: 32
          color: "white"
          text: "Highscore"
        }
      }
      Rectangle {
        color: "gray"
        width: (parent.width/2)
        height: (parent.height/6)
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 15
        opacity: 0.9
        Text {
          anchors.centerIn: parent
          font.pixelSize: 32
          color: "white"
          text: settings.maximumHighscore
        }
      }
      Rectangle {
        color: "transparent"
        width: (parent.width/2)
        height: (parent.height/6)
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 15
        opacity: 0.9
        Text {
          anchors.centerIn: parent
          font.pixelSize: 32
          color: "white"
          text: "Score"
        }
      }
      Rectangle {
        color: "gray"
        width: (parent.width/2)
        height: (parent.height/6)
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 15
        opacity: 0.9
        Text {
          anchors.centerIn: parent
          font.pixelSize: 32
          color: "white"
          text: score
        }
      }
    }
    /////

    Rectangle {
      anchors.horizontalCenter: parent.horizontalCenter
      color: "black"
      anchors.bottom: parent.bottom
      anchors.horizontalCenterOffset: -64
      anchors.bottomMargin: 10
      width: 48
      height: 48
      radius: 50
      Image {
        anchors.fill: parent
        scale: 0.6
        source: "../assets/gui/menu.png"
      }
      MouseArea {
        anchors.fill: parent
        onClicked: {
          gameOverTable.visible = false
          frog.revive()
          gameWindow.state = "menu"
        }
      }
    }
    Rectangle {
      anchors.horizontalCenter: parent.horizontalCenter
      color: "black"
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 10
      width: 48
      height: 48
      radius: 50
      Image {
        anchors.fill: parent
        scale: 0.8
        source: "../assets/gui/restart.png"
      }
      MouseArea {
        anchors.fill: parent
        onClicked: {
          score = 0
          frog.revive()
          gameOverTable.visible = false
        }
      }
    }
    Rectangle {
      anchors.horizontalCenter: parent.horizontalCenter
      color: "black"
      anchors.horizontalCenterOffset: 64
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 10
      width: 48
      height: 48
      radius: 50
      Image {
        anchors.fill: parent
        scale: 0.8
        source: "../assets/gui/star.png"
      }
      MouseArea {
        onClicked: {
          ga.logEvent("Click", "Market")
          nativeUtils.openUrl("market://details?id=com.theonebehind.MasterFrogSenpai")
        }
      }
    }
  }

  onBackButtonPressed: {
    gameWindow.state = "menu"
  }

  Text {
    id: perfectText
    anchors.centerIn: parent
    anchors.verticalCenterOffset: -100
    text: "Perfect"
    color: "white"
    font.pixelSize: 48
    opacity: 0

    NumberAnimation {
      id: perfectAnimation
      target: perfectText
      property: "opacity"
      running: false
      duration: 1000
      from: 0.8
      to: 0
    }
  }

}
