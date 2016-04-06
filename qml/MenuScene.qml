import VPlay 2.0
import QtQuick 2.0
import VPlayPlugins.googleanalytics 1.0
import VPlayPlugins.admob 1.0
import VPlayPlugins.chartboost 1.1

SceneBase {
  id:menuScene

  // signal indicating that the gameScene should be displayed
  signal gameScenePressed
  property var selectedCluster: ""

  Component.onCompleted: {
    backgroundMusic.play()
  }

  MultiResolutionImage {
    source: "../assets/bg.png"
    anchors.centerIn: menuScene.gameWindowAnchorItem
  }

  MultiResolutionImage {
    source: "../assets/title.png"
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    scale: 0.8
  }

  MultiResolutionImage {
    source: "../assets/playButton.png"
    anchors.centerIn: parent
    anchors.verticalCenterOffset: 50
    scale: 0.8
    MouseArea {
      anchors.fill: parent
      scale: 0.6
      onClicked: {
        gameScenePressed()
        playButtonSound.play()
      }
    }
  }

  Rectangle {
    color: "transparent"
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.verticalCenter


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

    Column {
      anchors.bottom: parent.bottom
      anchors.right: parent.right

      Rectangle {
        width: 36
        height: 36
        color: "black"
        opacity: 0.8
        radius: 25

        Image {
          source: "../assets/gui/char.png"
          anchors.fill: parent
        }
        MouseArea {
          anchors.fill: parent
          onClicked: {
            store.isOpen ? store.close() : store.open()
          }
        }
      }
      Rectangle {
        width: 36
        height: 36
        color: "black"
        opacity: 0.8
        radius: 25

        Image {
          source: settings.soundEnabled ? "../assets/gui/soundOn.png" : "../assets/gui/soundOff.png"
          anchors.fill: parent
          MouseArea {
            anchors.fill: parent
            onClicked: {
              settings.soundEnabled = !settings.soundEnabled
              settings.musicEnabled = !settings.musicEnabled
              cheatMoney++
              if(cheatMoney == 25) {
                coins = 1000
                settings.setValue("coins", 1000)
                coinSound.play()
                ga.logEvent("Click", "Money cheat")
              }
              if(cheatMoney == 40) {
                settings.setValue("showAds", false)
                coinSound.play()
                ga.logEvent("Click", "Ads cheat")
              }
            }
          }
        }
      }
    }
  }
  Store {
    id: store
    anchors.centerIn: parent
    visible: store.isOpen
  }
  onBackButtonPressed: {
    ga.logEvent("Click", "Back Button")
    nativeUtils.displayMessageBox(qsTr("Do you really want to quit?"), "", 2); // ??? make proper button
  }
  // listen to the return value of the MessageBox
      Connections {
        target: nativeUtils
        onMessageBoxFinished: {
          // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
          if(accepted && gameWindow.activeScene === menuScene)
            Qt.quit()
        }
      }
}
