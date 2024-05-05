import Charolette
import PlaydateKit

/// The subsystem for displaying, placing, and collecting packages.
final class PackageSubsystem: Subsystem {
    override func process() {
        for index in 0..<GameConstants.boxCount {
            let distanceToPlayer = GameData.player?.position
                .distance(to: GameData.boxes[index]) ?? .zero
            if distanceToPlayer >= 32 { continue }
            GameData.boxes[index].y = -GameConstants.charlieSize.y
            GameData.boxesCollected += 1
        }
    }

    override func draw() -> Bool {
        guard let boxOnFrame = GameResource.boxOnFrame,
              let boxOffFrame = GameResource.boxOffFrame else {
                GameData.gameOverState = .crash
                Playdate.System.log("Missing image data for boxes.")
                return true
        }

        GameData.boxFrame = (GameData.playerFrame > 2) ? 1 : 0
        for index in 0..<GameConstants.boxCount {
            GameData.boxes[index] = Boxes.shift(
                box: GameData.boxes[index],
                threshold: -GameConstants.charlieSize.y,
                index: index,
                screen: GameData.screen,
                totalBoxes: GameConstants.boxCount)

            Gameloop.drawBox(
                from: GameData.boxes,
                at: index,
                boxFrame: GameData.boxFrame,
                boxOnFrame: boxOnFrame, 
                boxOffFrame: boxOffFrame)
        }
        return true
    }
}