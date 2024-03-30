import XCTest
import Charolette

final class VectorTests: XCTestCase {
    func testVectorAddition() throws {
        let result = Vector2<Int>.one + Vector2<Int>.one
        XCTAssertEqual(result, Vector2(x: 2, y: 2))
    }

    func testVectorSubtraction() throws {
        let two: Vector2<Int> = Vector2(x: 2, y: 2)
        let subbed = two - two
        XCTAssertEqual(subbed, Vector2<Int>.zero)
    }

    func testVectorDistance() throws {
        let distance = Vector2<Int>.one.distance(to: Vector2<Int>.zero)
        XCTAssertEqual(distance, 1)

        let two: Vector2<Float> = Vector2(x: 2, y: 2)
        let farther = two.distance(to: Vector2<Float>.zero)
        XCTAssertEqual(farther, sqrtf(8))
    }
}