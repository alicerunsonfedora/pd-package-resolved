import Charolette
import PlaydateKit

/// The subsystem that controls displaying and placement of palette obstacles.
final class PaletteSubsystem: Subsystem {
    override var requiresManagedDrawCallsFromSprite: Bool { true }
    
    override func process() {
        if !GameData.initializedGameLoop || GameData.paletteGracePeriodActive { return }
        // if GameData.palettes.count != GameConstants.paletteCount {
        //     Playdate.System.log("Palettes were not filled! This is very, very bad.")
        //     GameData.gameOverState = .crash
        //     return
        // }

        for _ in 0..<GameConstants.paletteCount {
            let overlappingCounts = GameData.player?.sprite.overlappingSprites.count ?? 0
            if overlappingCounts <= 0 {
                continue
            }
            GameData.gameOverState = .injury
        }
    }

    override func draw() -> Bool {
        if GameData.paletteGracePeriodActive || !GameData.initializedGameLoop { return true }

        guard let paletteImage = GameResource.paletteImage else {
            GameData.gameOverState = .crash
            return false
        }

        if GameData.palettes.count == GameConstants.paletteCount {
            for index in 0..<GameConstants.paletteCount {
                GameData.palettes[index] = Palettes.shift(
                    palette: GameData.palettes[index],
                    threshold: -GameConstants.charlieSize.y,
                    screen: GameData.screen,
                    image: paletteImage)
            }
            return true
        }
        Palettes.fill(palettes: &GameData.palettes,
                      to: GameConstants.paletteCount,
                      screen: GameData.screen,
                      image: paletteImage)
        return true
    }
}