import Charolette
import PlaydateKit

class Player {
    var sprite: Playdate.Sprite.Sprite
    var frame: Playdate.Graphics.Bitmap
    var position: Vector2<Float>
    var size: Vector2<Float>
    var collisionRect: Playdate.Sprite.Rect

    init(at position: Vector2<Float>, size: Vector2<Float>, table: Playdate.Graphics.BitmapTable) {
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
        sprite.moveTo(x: newPosition.x, y: newPosition.y)
        position = newPosition
    }

    func update(using table: Playdate.Graphics.BitmapTable, frame: Int) {
        guard let realFrame = table.bitmap(at: CInt(frame)) else {
            fatalError("Missing the specified frame in the player table.")
        }
        sprite.setImage(image: realFrame)
        sprite.moveTo(x: sprite.position.x, y: sprite.position.y)
        sprite.markDirty()
        self.frame = realFrame
    }
}