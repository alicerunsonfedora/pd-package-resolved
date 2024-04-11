import Charolette
import PlaydateKit

enum GameOverState {
    case outOfTime
    case injury
    case crash
    case success
}

enum Gameloop {
    typealias Box = Vector2<Float>
    typealias Bitmap = Playdate.Graphics.Bitmap
    typealias BitmapTable = Playdate.Graphics.BitmapTable

    enum GameloopError: Error {
        case tableNotFound
        case bitmapNotFound
    }

    static func drawBox(from boxes: [Box], at index: Int, boxFrame: Int, boxOnFrame: Bitmap, boxOffFrame: Bitmap) {
        let box = boxes[index]
        let even = index % 2 == 0
        switch (boxFrame, even) {
        case (1, true), (0, false):
            self.drawBox(box: box, image: boxOnFrame)
        case (1, false), (0, true):
            self.drawBox(box: box, image: boxOffFrame)
        default:
            break
        }
    }

    @inlinable
    static func drawBox(box: Box, image: Bitmap) {
        Playdate.Graphics.drawBitmap(image, position: box, flip: .bitmapUnflipped)
    }

    static func getBoxTable() throws(GameloopError) -> (Bitmap, Bitmap) {
        let boxSheet: StaticString = "Images/box"
        let table = BitmapTable(path: boxSheet)
        let onFrame = table.bitmap(at: 0)
        let offFrame = table.bitmap(at: 1)

        if onFrame == nil || offFrame == nil {
            throw .bitmapNotFound
        }

        return (onFrame!, offFrame!)
    }

    static func cycleFrames(frame: inout Int, updated: inout Bool) {
        if updated {
            updated = false
            return
        }
        frame = (frame + 1).clamp(lower: 0, upper: 5)
        updated = true
    }
}

extension Playdate.Graphics {
    static func drawBitmap(_ bitmap: Bitmap, position: Vector2<Float>, flip: Bitmap.Flip) {
        Self.drawBitmap(bitmap, x: CInt(position.x), y: CInt(position.y), flip: flip)
    }
}