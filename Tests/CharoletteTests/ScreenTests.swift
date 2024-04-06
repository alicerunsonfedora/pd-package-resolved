import XCTest
import Charolette

final class ScreenTests: XCTestCase {
    typealias Point = Vector2<Float>

    let screen = ScreenData(bounds: Point(x: 400.0, y: 240.0),
                            insets: EdgeInsets(vertical: 4, horizontal: 8))

    func testFencingNoTransform() throws {
        let noClamped = Point(x: 10.0, y: 16.0)
        let result = screen.fencingIn(point: noClamped)
        XCTAssertEqual(result, Point(x: 10.0, y: 16.0))
    }

    func testFencingTopLeftCorner() throws {
        let result = screen.fencingIn(point: Vector2<Float>.zero)
        XCTAssertEqual(result, Point(x: 8.0, y: 4.0))
    }

    func testFencingTopEdge() throws {
        let result = screen.fencingIn(point: Point(x: 16, y: 1))
        XCTAssertEqual(result, Point(x: 16, y: 4))
    }

    func testFencingTopRightCorner() throws {
        let result = screen.fencingIn(point: Point(x: 400, y: 1))
        XCTAssertEqual(result, Point(x: 392, y: 4))
    }

    func testFencingLeftEdge() throws {
        let result = screen.fencingIn(point: Point(x: 0, y: 40))
        XCTAssertEqual(result, Point(x: 8, y: 40))
    }

    func testFencingRightEdge() throws {
        let result = screen.fencingIn(point: Point(x: 420, y: 40))
        XCTAssertEqual(result, Point(x: 392, y: 40))
    }

    func testFencingBottomLeftCorner() throws {
        let result = screen.fencingIn(point: Point(x: 0, y: 240))
        XCTAssertEqual(result, Point(x: 8,y: 236))
    }

    func testFencingBottomEdge() throws {
        let result = screen.fencingIn(point: Point(x: 16, y: 240))
        XCTAssertEqual(result, Point(x: 16, y: 236))
    }

    func testFencingBottomRightCorner() throws {
        let result = screen.fencingIn(point: screen.bounds)
        XCTAssertEqual(result, Point(x: 392, y: 236))
    }
}