import XCTest
import CharoletteStandard

final class MovementTests: XCTestCase {
    func testMovementTranslation() throws {
        let originalPosition = Vector2<Float>(x: 15.0, y: 0.0)
        let translated = Movement.translate(from: originalPosition,
                                            withCrankRotation: 15.69,
                                            bounds: Vector2<Float>(x: 400.0, y: 240.0))
        XCTAssertEqual(translated, Vector2<Float>(x: 15.69, y: 0))
    }
}