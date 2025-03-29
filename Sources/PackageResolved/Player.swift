import Charolette
import PlaydateKit

class Player {
    var sprite: Sprite.Sprite
    var frame: Graphics.Bitmap
    var position: Vector2<Float>
    var size: Vector2<Float>
    var collisionRect: Rect

    init(at position: Vector2<Float>, size: Vector2<Float>, table: Graphics.BitmapTable) {
        self.collisionRect = .init(x: 8, y: 48, width: size.x - 16, height: 16)
        self.position = position
        self.size = size

        guard let firstFrame = table.bitmap(at: 0) else {
            fatalError("Missing first frame in the player table.")
        }
        self.frame = firstFrame

        let sprite = Images.imagedSprite(bitmap: firstFrame, at: position)
        sprite.collisionsEnabled = true
        sprite.collideRect = collisionRect
        self.sprite = sprite
    }

    func move(to newPosition: Vector2<Float>) {
        sprite.moveTo(Point(x: Int(newPosition.x), y: Int(newPosition.y)))
        position = newPosition
    }

    func update(using table: Graphics.BitmapTable, frame: Int) {
        guard let realFrame = table.bitmap(at: frame) else {
            fatalError("Missing the specified frame in the player table.")
        }
        sprite.image = realFrame
        sprite.moveTo(Point(x: sprite.position.x, y: sprite.position.y))
        sprite.markDirty()
        self.frame = realFrame
    }
}
