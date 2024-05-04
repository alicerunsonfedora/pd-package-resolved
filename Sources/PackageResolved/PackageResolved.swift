import Charolette
import PlaydateKit

// MARK: Gameloop handler

final class PackageResolvedGameloop {
    init() {}

    private func processPalettes() {
        if GameData.palettes.count != GameConstants.paletteCount {
            Playdate.System.log("What are you doing?!")
            GameData.gameOverState = .crash
        }

        for _ in 0..<GameConstants.paletteCount {
            let overlappingCounts = GameData.player?.sprite.overlappingSprites.count ?? 0
            if overlappingCounts <= 0 {
                continue
            }
            GameData.gameOverState = .injury
        }
    }

    private func processBoxes() {
        for index in 0..<GameConstants.boxCount {
            let distanceToPlayer = GameData.player?.position
                .distance(to: GameData.boxes[index]) ?? .zero
            if distanceToPlayer < 32 {
                GameData.boxes[index].y = -GameConstants.charlieSize.y
            }
        }
    }

    private func processTime() {
        let timeSinceReset = Int(Playdate.System.elapsedTime)
        GameData.timeRemaining = 60 - timeSinceReset

        if GameData.timeRemaining == 55 {
            GameData.paletteGracePeriodActive = false
        }

        if GameData.timeRemaining <= 0 {
            GameData.gameOverState = .outOfTime
        }
    }

    private func processInputs() {
        let (currentButtons, _, _) = Playdate.System.buttonState
        let currentXPosition = GameData.player?.position.x ?? 0

        var movementDelta: Float = -1
        if !Playdate.System.isCrankDocked {
            movementDelta = Playdate.System.crankAngle
        } else if currentButtons.contains(.left) {
            movementDelta = currentXPosition - 4
        } else if currentButtons.contains(.right) {
            movementDelta = currentXPosition + 4
        }

        if movementDelta >= 0 {
            GameData.player?.move(to: Movement.translate(
                from: GameData.player?.position ?? .zero,
                withCrankRotation: movementDelta,
                bounds: GameData.screen.bounds))
        }
    }
}

// MARK: GameRunner conformance

extension PackageResolvedGameloop: GameRunner {
    func process() {
        if !GameData.initializedGameLoop {
            Playdate.System.log("Game loop not ready. Please call setup.")
            GameData.reset()
            return
        }

        if GameData.gameOverState != nil {
            let (_, _, released) = Playdate.System.buttonState
            if released.contains(.a) { GameData.reset() }
            return
        }

        if !GameData.paletteGracePeriodActive {
            processPalettes()
        }

        processBoxes()
        processTime()
        processInputs()

        Gameloop.cycleFrames(frame: &GameData.playerFrame, updated: &GameData.frameUpdated)
    }

    func draw() -> Bool {
        if !GameData.initializedGameLoop {
            return setup()
        }

        if let gameOverState = GameData.gameOverState {
            return UI.displayAlert(message: gameOverState.staticMessage, options: .displayRestart)
        }

        guard let playerTable = GameResource.playerTable else {
            GameData.gameOverState = .crash
            Playdate.System.error("Uh oh, where's the player table?")
            return false
        }

        GameData.player?.update(using: playerTable, frame: GameData.playerFrame)

        guard let paletteImage = GameResource.paletteImage else {
            GameData.gameOverState = .crash
            return false
        }

        if !GameData.paletteGracePeriodActive {
            if GameData.palettes.count == GameConstants.paletteCount {
                for index in 0..<GameConstants.paletteCount {
                    GameData.palettes[index] = Palettes.shift(
                        palette: GameData.palettes[index],
                        threshold: -GameConstants.charlieSize.y,
                        screen: GameData.screen,
                        image: paletteImage)
                }
            } else {
                Palettes.fill(
                    palettes: &GameData.palettes,
                    to: GameConstants.paletteCount,
                    screen: GameData.screen,
                    image: paletteImage)
            }
        }

        Playdate.Sprite.updateAndDrawDisplayListSprites()

        guard let boxOnFrame = GameResource.boxOnFrame,
            let boxOffFrame = GameResource.boxOffFrame else {
                GameData.gameOverState = .crash
                return false
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

        // NOTE: Allocate C string via UnsafeMutableBufferPointer.allocate - rauhul

        // TODO: Get this to show different phases of the clock, not just the full clock
        if let clockFrame = GameResource.clockFrame {
            Playdate.Graphics.drawBitmap(clockFrame,
                                        // TODO: this is NOT how math works
                                        position: Vector2(x: 32, y: 32) - GameData.screen.bounds,
                                        flip: .bitmapUnflipped)
        } else {
            Playdate.System.log("No clock?")
            return false
        }
        return true
    }
}