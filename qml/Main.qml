import VPlay 2.0
import QtQuick 2.0
import VPlayPlugins.googleanalytics 1.0
import VPlayPlugins.admob 1.0
import VPlayPlugins.chartboost 1.1

GameWindow {
  id: gameWindow

  licenseKey: "05A27B69D931DD531C3F624DAFB16F48370C602F031A97EE036A349520F7200209E88D1D7ADEE17DC3E691A382908E5AD839556D3348F1F392260A69DD877168BFF3CA676FF9A7E5CC2FF5BD3C9702E0992A99FC9B7C84D84DF781D1D182B36F1ADFD93606B1399293E87EC6477CC505A7CFDE93438EC5F381492A0EF48CFDB14EEEC47A6E9B43677537C7B33FBB8C790A51725EBBF73568AAE1043C454FE814219179A961129109CF56A3620C72C078293B1F3F99B55DFA8BB43402CAEA7279F2ED33FACFA685E3287A4D76D274EE286B64978943B7579EC11B854700A22298C93337692DFEFB53490F41B66C79229D6F76E1C8698663D1924DBD6566CFB5E52A2E5A9D5B63ED3F6572F2C6BA0EF7BAA4B061EBC0732F7B75AC6C94A030027C27E52CA76A31525BC3C77FFEF37C32389BD7AF0004B746C5E4004897F357F2842357F33258C3E80D986E04B8A924CFE2762203EE2B34D29303FF438AFCF39EF58FB5D2C8A034363B3A64BB6FD8D4598164B9948B15DD29359826BB9126B20ABE"

  activeScene: gameScene

  screenWidth: 320
  screenHeight: 480

  property int score
  property int showAdNum: 0
  property int coins: settings.getValue("coins")
  property int cheatMoney: 0

  Chartboost {
     id: chartboost

     appId: "56ff1fe15b145343e403cde2"
     appSignature: "fa21048906e88cf057ecf69444683f0a7ec01c55"

     // allows to show interstitial also at first app startup.
     // see http://plugins.v-play.net/doc/vplay-plugins-chartboost/#shouldRequestInterstitialsInFirstSession-prop
     shouldRequestInterstitialsInFirstSession: true

     // Do not use reward videos in this example
     shouldDisplayRewardedVideo: false

//     onInterstitialCached: {
//       console.debug("InterstitialCached at location:", location)
//     }

//     onInterstitialFailedToLoad: {
//       console.debug("InterstitialFailedToLoad at location:", location, "error:", error)
//     }
   }

  Component.onCompleted: {
    //settings.clearAll()
    //settings.setValue("coins", 5000)

    var firstTimeOpen = settings.getValue("firstTimeOpen")
    if(firstTimeOpen == undefined) {
      settings.setValue("coins", 0)
      settings.setValue("firstTimeOpen", true)
      settings.setValue("common", true)
      settings.setValue("white", false)
      settings.setValue("blue", false)
      settings.setValue("red", false)
      settings.setValue("black", false)
      settings.setValue("ninja", false)
      settings.setValue("senpai", false)
      settings.setValue("lastSuit", "common")
      settings.setValue("showAds", true)
    }

    if(settings.getValue("showAds"))
    chartboost.showInterstitial()
  }

  BackgroundMusic {
    id: backgroundMusic
    source: "../assets/theme.mp3"
    volume: 1.0
  }

  SoundEffectVPlay {
    id: playButtonSound
    source: "../assets/playButton.wav"
    volume: 0.3
  }
  SoundEffectVPlay {
    id: yumSound
    source: "../assets/yum.wav"
    volume: 0.3
  }
  SoundEffectVPlay {
    id: coinSound
    source: "../assets/coins.wav"
    volume: 0.3
  }

  GoogleAnalytics {
    id: ga
    propertyId: "UA-49979447-9"
  }

  EntityManager {
    id: entityManager
    entityContainer: gameScene
  }

  GameScene {
    id: gameScene
    onMenuScenePressed: {
      gameWindow.state = "menu"
      ga.logEvent("Click", "MenuScene")

    }
  }

  // the menu scene of the game
  MenuScene {
    id: menuScene
    onGameScenePressed: {
      gameWindow.state = "game"
      gameScene.refreshFrogg()
      score = 0
      cheatMoney = 0
      ga.logEvent("Click", "GameScene")
    }
  }

  state: "menu"

  // state machine, takes care reversing the PropertyChanges when changing the state like changing the opacity back to 0
  states: [
    State {
      name: "menu"
      PropertyChanges {target: menuScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: menuScene}
    },
    State {
      name: "game"
      PropertyChanges {target: gameScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: gameScene}
    }
  ]
}
