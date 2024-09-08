import Charolette
import PlaydateKit

/// A container for APIs pertaining to the game's user interface.
enum UI {
    /// A structure representing options to configure a user interface alert.
    struct AlertOptions: OptionSet {
        let rawValue: Int

        /// Display the "Press A to restart" message at the bottom of the screen.
        nonisolated(unsafe) static let displayRestart = AlertOptions(rawValue: 1 << 0)

        /// No options configured.
        nonisolated(unsafe) static let none: AlertOptions = []
    }

    /// Displays a blocking alert on the screen with the specified message.
    /// - Parameter message: The message to display in the center of the screen.
    /// - Parameter options: Additional options to configure the alert, such as whether to
    ///   whether to prompt the player to restart the game. Defaults to 'none'.
    /// - Returns: Whether the Playdate should redraw the screen.
    @discardableResult
    static func displayAlert(message: StaticString, options: AlertOptions = .none) -> Bool {
        let width = Playdate.Display.width
        let height = Playdate.Display.height

        guard let styledFont = GameResource.currentFont else {
            return false
        }

        let halfScreenWidth: Int = Int(width) / 2
        let halfHeight = CInt(styledFont.size / 2)
        let yOffset = (height / 2) - halfHeight

        Playdate.Graphics.clear(color: 1)
        Playdate.Graphics.drawRect(x: 8, y: 8, width: width - 16, height: height - 16)

        _ = message.withUTF8Buffer { string in
            let stringWidth = Self.width(of: string, using: styledFont)

            return Playdate.Graphics.drawText(
                string.baseAddress,
                length: string.count,
                encoding: .kUTF8Encoding,
                x: CInt(halfScreenWidth) - stringWidth / 2,
                y: yOffset)
        }

        if options.contains(.displayRestart) {
            let restartMsg: StaticString = "Press A to restart"
            _ = restartMsg.withUTF8Buffer { string in
                let stringWidth = Self.width(of: string, using: styledFont)
                
                return Playdate.Graphics.drawText(
                    string.baseAddress,
                    length: string.count,
                    encoding: .kUTF8Encoding,
                    x: CInt(halfScreenWidth) - stringWidth / 2,
                    y: height - CInt(styledFont.size) - 16
                )
            }
        }
        return true
    }

    private static func width(
        of string: UnsafeBufferPointer<UInt8>,
        using fontSet: FontSet
    ) -> CInt {
        guard let baseAddress = string.baseAddress else { return -1 }
        return fontSet.font.getTextWidth(for: baseAddress,
                                         length: string.count,
                                         encoding: .kUTF8Encoding,
                                         tracking: 0) 
    }

    @discardableResult
    static func drawText(_ text: String, at position: Vector2<Int>) -> Int {
       Playdate.Graphics.drawText(text, x: CInt(position.x), y: CInt(position.y))
    }
}
