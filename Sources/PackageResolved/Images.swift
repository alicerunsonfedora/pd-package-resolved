import Charolette
import PlaydateKit

enum Images {
    typealias Bitmap = Graphics.Bitmap
    
    static func imagedSprite(bitmap: Bitmap, at size: Vector2<Float>) -> Sprite.Sprite {
        let sprite = Sprite.Sprite()
        sprite.setSize(width: size.x, height: size.y)
        sprite.image = bitmap
        sprite.addToDisplayList()
        return sprite
    }
}
