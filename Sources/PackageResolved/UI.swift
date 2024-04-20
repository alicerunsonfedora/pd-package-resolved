import Charolette
import PlaydateKit

enum UI {
    static func displayAlert(message: StaticString) -> Bool {
        let width = Playdate.Display.width
        let height = Playdate.Display.height

        guard let styledFont = GameResource.currentFont else {
            return false
        }

        let halfHeight = CInt(styledFont.size / 2)
        let yOffset = (height / 2) - halfHeight

        Playdate.Graphics.clear(color: 1)
        Playdate.Graphics.drawRect(x: 8, y: 8, width: width - 16, height: height - 16)

        _ = message.withUTF8Buffer { string in
            let halfScreenWidth: Int = Int(width) / 2
            let stringWidth = styledFont.font.getTextWidth(
                for: string.baseAddress!,
                length: string.count,
                encoding: .kUTF8Encoding,
                tracking: 0)

            return Playdate.Graphics.drawText(
                string.baseAddress,
                length: string.count,
                encoding: .kUTF8Encoding,
                x: CInt(halfScreenWidth) - stringWidth / 2,
                y: yOffset)
        }

        return true
    }
}