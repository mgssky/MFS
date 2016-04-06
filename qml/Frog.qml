import QtQuick 2.0
import VPlay 2.0
import VPlayPlugins.googleanalytics 1.0


EntityBase {
  id:frog

  entityType: "Frog"

  state: "standing"


  property int jumpingImpulseX: -250
  property int jumpingImpulseY: -700
  property int refRotation: 0
  property bool rightStand: false
  property bool leftStand: false

  function refreshFrog() {
    frogAnimation.defaultSource = "../assets/" + settings.getValue("lastSuit") + ".png"
  }

  SpriteSequenceVPlay {
    id: frogAnimation

    defaultSource: "../assets/" + settings.getValue("lastSuit") + ".png"
    scale: 0.6
    anchors.centerIn: frogCollider

    SpriteVPlay {
      name: "standing"
      frameWidth: 128
      frameHeight: 128
      frameCount: 4
      frameRate: 10
      //reverse: true
    }
    SpriteVPlay {
      name: "standingLeft"
      frameWidth: 128
      frameHeight: 128
      frameCount: 4
      frameRate: 10
      frameY: 128
    }

    SpriteVPlay {
      name: "jumping"
      frameCount: 3
      frameRate: 8

      frameWidth: 128
      frameHeight: 128
      //startFrameColumn: 1
      frameY: 256+128
    }

    SpriteVPlay {
      name: "bubbling"
      frameCount: 3
      frameRate: 8

      frameWidth: 128
      frameHeight: 128
      frameY: 256
    }
  }

  BoxCollider {
    id: frogCollider

    width: 20 // width of the frog collider
    height: 20 // height of the frog collider

    //bodyType: gameScene.state == "playing" ?  Body.Dynamic : Body.Static // do not apply gravity when the frog is dead or the game is not started
    bodyType: Body.Dynamic

    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
      var otherEntityType = otherEntity.entityType

      if(otherEntityType === "Border") {
        gameOverTable.visible = true
        die()
      }

      if(otherEntityType === "Fly") {
        otherEntity.die()
        yumSound.play()
        coins = coins + 3
        settings.setValue("coins", coins)

      }


      if(otherEntityType === "Pillar" && frog.y < otherEntity.y-10) {

        if(gameFly.state === "dead" && (Math.random()*100) < 7)
          gameFly.revive()


        frogAnimation.rotation = 0;
        score++

        if(otherEntity.x-frogCollider.x > 160+15-10) {
          jumpingImpulseY = -900
          jumpingImpulseX = -200
          refRotation =  15
          leftStand = true

        }
        else
          if(otherEntity.x-frogCollider.x < 160+15-10 && otherEntity.x-frogCollider.x > 160-15-10) {
            jumpingImpulseY = -850
            jumpingImpulseX = -250
            refRotation =  30
            if(otherEntity.x-frogCollider.x < 160+4-10 && otherEntity.x-frogCollider.x > 160-4-10) {
              perfectAnimation.start()
              coins++
              settings.setValue("coins", coins)
              coinSound.play()
              sp.start(otherEntity.x-45, otherEntity.y-65)
            }
          }
          else
            if(otherEntity.x-frogCollider.x < 160-15-10) {
              jumpingImpulseY = -800
              jumpingImpulseX = -300
              refRotation =  50
              rightStand = true
            }
                frog.state = "standing"
      }
    }
  }


  onYChanged: {
        if(frog.state !== "standing" && mouseArea.pressed) {
                jumpingImpulseX = -250
                frogCollider.linearVelocity.y = 50
                frogAnimation.jumpTo("bubbling")
        }
        if(frog.state !== "standing" && !mouseArea.pressed && frogCollider.linearVelocity.y > 0) {
                frogAnimation.rotation =  0
                frogAnimation.jumpTo("standing")
        }
  }

  onStateChanged: {
    if(frog.state === "jumping") {

      frogAnimation.mirrorX = false
      frogAnimation.rotation = refRotation
      frogAnimation.jumpTo("jumping") // change the current animation to jumping

    }

    if(frog.state === "standing") {

      if(leftStand) {
        frogAnimation.jumpTo("standingLeft")
        leftStand = false
      }
      else
        if(rightStand) {
          frogAnimation.jumpTo("standingLeft")
          frogAnimation.mirrorX = true
          rightStand = false
        }
        else {
          frogAnimation.jumpTo("standing")
        }
    }
  }


  function move() {
    if(frog.state === "standing") {
      frog.y = frog.y - 10
      frog.state = "jumping"
      frogCollider.linearVelocity.y = 0;
      frogCollider.applyLinearImpulse(Qt.point(0,jumpingImpulseY))
    }
  }
  function die() {
    //frog.visible = false

    ga.logEvent("Score", score)
    jumpingImpulseX = 0
    visible = false
    if(score > settings.maximumHighscore) {
      settings.maximumHighscore = score
    }

    if(settings.getValue("showAds"))
    showAd()
  }

  function revive() {

    frog.state = "standing"
    frogAnimation.rotation = 0
    frog.y = 300
    frog.x = (gameScene.width/2)
    jumpingImpulseX = 0
    jumpingImpulseY = 0
    frogCollider.linearVelocity.y = 0

    pil1.x = gameScene.width/2
    pil1.y = 330
    pil2.x = (gameScene.width/2)+250+(200*Math.random())
    pil2.y = 330
    pil3.x = (gameScene.width/2)+550+(200*Math.random())
    pil3.y = 330

    lastPillar = pil3
    visible = true
    gameFly.die()
  }
}
