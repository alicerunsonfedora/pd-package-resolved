import Charolette
import PlaydateKit

enum GameOverState {
    case outOfTime
    case injury
    case crash
    case success

    var staticMessage: StaticString {
        switch self {
        case .outOfTime:
            "You couldn't complete\n\tthe mission in time."
        case .injury:
            "You got seriously injured."
        case .crash:
            "A serious error occurred\n\tand the game couldn't recover."
        case .success:
            "Congrats!\nYou completed the mission."
        }
    }

    var message: String {
        switch self {
        case .outOfTime:
            "You couldn't complete\n\tthe mission in time."
        case .injury:
            "You got seriously injured."
        case .crash:
            "A serious error occurred\n\tand the game couldn't recover."
        case .success:
            "Congrats!\nYou completed the mission."
        }
    }
}

extension GameOverState: Equatable {}

enum Gameloop {
    typealias Box = Vector2<Float>
    typealias Bitmap = Graphics.Bitmap
    typealias BitmapTable = Graphics.BitmapTable

    enum GameloopError: Error {
        case tableNotFound
        case bitmapNotFound
    }

    static func drawBox(
        from boxes: [Box],
        at index: Int,
        boxFrame: Int,
        boxOnFrame: Bitmap,
        boxOffFrame: Bitmap
    ) {
        let box = boxes[index]
        let even = index % 2 == 0
        switch (boxFrame, even) {
        case (1, true), (0, false):
            self.drawBox(box: box, image: boxOnFrame)
        default:
            self.drawBox(box: box, image: boxOffFrame)
        }
    }

    @inlinable
    static func drawBox(box: Box, image: Bitmap) {
        Graphics.drawBitmap(image, at: Point(x: Int(box.x), y: Int(box.y)), flip: .unflipped)
    }

    static func getBoxTable() throws(GameloopError) -> (Bitmap, Bitmap) {
        let boxSheet: String = "Images/box"
        guard let table = try? BitmapTable(path: boxSheet) else {
            throw .bitmapNotFound
        }
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
        frame += 1
        if frame > 5 { frame = 0 }
        updated = true
    }
}
