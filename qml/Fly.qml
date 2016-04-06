import QtQuick 2.0
import VPlay 2.0

EntityBase {
  id: fly
  entityType: "Fly"

  state: "alive"

  SpriteSequenceVPlay {
    id: flyAnimation

    defaultSource: "../assets/fly2.png"
    //anchors.centerIn: frogCollider
    scale: 0.3
    anchors.centerIn: parent

    SpriteVPlay {
      name: "standing"
      frameWidth: 128
      frameHeight: 128
      frameCount: 2
      frameRate: 10
      //reverse: true
    }
  }

  BoxCollider {
    id: imageCollider
    width: 20
    height: 20
    bodyType: Body.Static
    collisionTestingOnlyMode: true
  }

  MovementAnimation {
    id: movementX
    target: fly
    property: "x"
    minPropertyValue: -50
    velocity:  -30
    running: fly.state === "alive"
    onLimitReached: {
      console.log("fly is dead")
      die()
    }
  }
  MovementAnimation {
    id: movementY
    target: fly
    property: "y"
    velocity:  Math.sin(fly.x/10)*150
    running: fly.state === "alive"
  }

  function die() {
    state = "dead"
    x  = 400
    y = 90
  }

  function revive() {
    state = "alive"
  }
}


