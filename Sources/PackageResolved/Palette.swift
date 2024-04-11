import Charolette
import PlaydateKit

struct Palette {
    var sprite: Playdate.Sprite.Sprite
    var position: Vector2<Float>

    init(sprite: Playdate.Sprite.Sprite, position: Vector2<Float>) {
        self.sprite = sprite
        self.position = position
    }

    init(image: Playdate.Graphics.Bitmap, at position: Vector2<Float>) {
        self.sprite = Images.imagedSprite(bitmap: image, at: position)
        self.position = position
    }
}

enum Palettes {
    typealias Bitmap = Playdate.Graphics.Bitmap

    private enum Constants {
        static var paletteSize: Vector2<Float> { Vector2(x: 32, y: 32) }
    }

    static func fill(palettes: inout [Palette], screen: ScreenData, image: Bitmap) {
        for index in 0..<palettes.count {
            let position = createPalettePosition(screen: screen)
            let current = Palette(image: image, at: position)
            current.sprite.collisionsEnabled = true
            current.sprite.collideRect = .init(x: 4, y: 8, width: Constants.paletteSize.x - 8, height: Constants.paletteSize.y - 8)
            palettes[index] = current
        }
    }

    static func shift(palette: Palette, threshold: Float, screen: ScreenData, image: Bitmap) -> Palette {
        var newPosition = palette.position
        newPosition.y -= 1
        if newPosition.y < threshold { newPosition = createPalettePosition(screen: screen) }

        palette.sprite.setImage(image: image)
        palette.sprite.moveTo(x: newPosition.x, y: newPosition.y)
        palette.sprite.markDirty()
        
        return Palette(sprite: palette.sprite, position: newPosition)
    }

    private static func createPalettePosition(screen: ScreenData) -> Vector2<Float> {
        let xPosition = Float.random(in: 0...screen.bounds.x)
        let yPosition = Float.random(in: 128...screen.bounds.y)
        let originalPosition = Vector2<Float>(x: xPosition, y: yPosition)
        return screen.fencingIn(point: originalPosition)
    }
}