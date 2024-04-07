import XCTest
import Charolette

final class BoxTests: XCTestCase {
    let screenData = ScreenData(bounds: Vector2<Float>(x: 400, y: 240), insets: .zero)
    let screenDataWithInsets = ScreenData(bounds: Vector2<Float>(x: 400, y: 240),
                                                      insets: EdgeInsets(vertical: 0, horizontal: 32))

    func testFillBox() throws {
        var boxes = Array(repeating: Vector2<Float>.zero, count: 3)
        Boxes.fill(boxes: &boxes, screen: screenData)

        for (index, box) in boxes.enumerated() {
            XCTAssertLessThanOrEqual(box.x, 400.0)
            XCTAssertNotEqual(box.x, 0)
            XCTAssertEqual(box.y, Float(80 * index))
        }
    }

    func testFillBoxWithInsets() throws {
        var boxes = Array(repeating: Vector2<Float>.zero, count: 3)
        Boxes.fill(boxes: &boxes, screen: screenDataWithInsets)

        for (index, box) in boxes.enumerated() {
            XCTAssertLessThanOrEqual(box.x, 368.0)
            XCTAssertNotEqual(box.x, 32)
            XCTAssertEqual(box.y, Float(80 * index))
        }
    }

    func testShiftBox() throws {
        var simpleShift = Vector2<Float>(x: 300, y: 40)
        simpleShift = Boxes.shift(box: simpleShift, threshold: 32, index: 0, screen: screenData, totalBoxes: 1)
        XCTAssertEqual(simpleShift.y, 39)
    }

    func testShiftBoxOverThreshold() throws {
        var newAssignment = Vector2<Float>(x: 100, y: -46)
        newAssignment = Boxes.shift(box: newAssignment, threshold: 32, index: 0, screen: screenData, totalBoxes: 1)
        XCTAssertTrue(newAssignment.y > 0)
    }
}