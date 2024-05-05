import PlaydateKit

enum Fonts {
    typealias Font = Playdate.Graphics.Font

    private enum Constants {
        static let sBoldPath: StaticString = "Fonts/Salmon-Sans-9-Bold-18.pft"
        static let sBoldFallback: StaticString = "/System/Fonts/Asheville-Sans-14-Bold.pft"
    }

    enum FontError: Error {
        case noSuitableFontFound
    }

    /// Retrieves a font set based on specified style parameters.
    /// - Parameter style: The font style to get the font set of.
    /// - Returns: The font set for the specified style.
    static func styledFont(for style: FontStyle) throws(FontError) -> FontSet {
        switch (style) {
        case .bold:
            guard let font = Self.boldStyledFont() else {
                throw .noSuitableFontFound
            }
            let fontSize = Int(font.height)
            return FontSet(font: font, size: fontSize)
        }
    }

    private static func boldStyledFont() -> Font? {
        let font = try? Font(path: Constants.sBoldPath)
        if font != nil { return font }
        return try? Font(path: Constants.sBoldFallback)
    }
}

/// An enumeration representing the different font styles the game can offer.
enum FontStyle {
    case bold
}

/// A structure that contains information about a font.
struct FontSet {
    /// The Playdate LCD font that can be rendered to the screen.
    /// 
    /// Typically, this is used with `pd->graphics->loadFont` to load the font as the current one.
    var font: Graphics.Font

    /// The height of the font in pixels.
    var size: Int
}