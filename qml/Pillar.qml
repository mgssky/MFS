import QtQuick 2.0
import VPlay 2.0

EntityBase {
  id: pillar
  entityType: "Pillar"

  BoxCollider {
    id: pillarCollider
    width: 40
    height: 5
    bodyType: Body.Static // this body shall not move
    //gravityScale: 0
    collisionTestingOnlyMode: false

    onXChanged: console.log("working?")

    // a Rectangle to visualize the border
      MultiResolutionImage {
      id: name
      source: "../assets/pillar.png"
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 117

      //scale: 0.25
    }
  }

  function respawn() {
    pillar.x = gameScene.width
  }

  // platform movement
  MovementAnimation {
    id: movement
    target: pillar
    property: "x"
    minPropertyValue: -150
    velocity:  frog.jumpingImpulseX
    running: frog.state === "jumping" || frog.state === "falling"
    onLimitReached: {
      pillar.x =  lastPillar.x+150+(Math.random()*500) // lastPillar.x+350+Math.random()*100
      lastPillar = pillar
    }
  }

}


