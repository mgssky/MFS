import QtQuick 2.0
import VPlay 2.0


EntityBase {
  id:specialEffect // the id we use as a reference inside this class

  entityType: "SpecialEffect" // always name your entityTypes

  Rectangle {
    id: rect
    color: "black"
    anchors.centerIn: parent
    width: 20
    height: 20
    visible: false
  }

  SpriteSequenceVPlay {
    id: specialEffectAnimation

    defaultSource: "../assets/puff.png"
    scale: 1 // our image is too big so we reduce the size of the original image to 35%
    // when frog jumps it turns to the direction he moves

    running: true
    SpriteVPlay {
      name: "one"
      frameCount: 8
      frameRate: 20

      frameWidth: 128
      frameHeight: 128
      to: {"two": 1}
      //startFrameColumn: 2
      //frameY: 0
    }
    SpriteVPlay {
      name: "two"
      frameWidth: 1
      frameHeight: 1
    }
  }

  function start(x, y) {
      specialEffect.x = x;
      specialEffect.y = y;
      specialEffectAnimation.jumpTo("one")
  }
}
