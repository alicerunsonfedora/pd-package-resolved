import Charolette
import PlaydateKit

enum Images {
    typealias Sprite = Playdate.Sprite.Sprite
    typealias Bitmap = Playdate.Graphics.Bitmap
    
    static func imagedSprite(bitmap: Bitmap, at size: Vector2<Float>) -> Sprite {
        let sprite = Sprite()
        sprite.setSize(width: size.x, height: size.y)
        sprite.setImage(image: bitmap)
        sprite.addToDisplayList()
        return sprite
    }
}