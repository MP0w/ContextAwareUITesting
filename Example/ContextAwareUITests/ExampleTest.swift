import XCTest

class ExampleTest: XCTestCase {
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let flow = ScreenOne()
            .whenVisible()
            .goToScreenTwo()
            .whenVisible()
            .goToScreenThree()
            .whenVisible()
            .dismiss()
            .whenVisible().end()
        
        verify(flow: flow, app: app)
    }
}

struct ScreenOne: Screen {
    var id: String { "screen.one" }
    let previous: Step
    
    init(previous: Step) {
        self.previous = previous
    }
    
    func goToScreenTwo() -> ScreenTwo {
        ScreenTwo(previous: Step(action: .buttonTap(id: "next"), context: id, previous: previous))
    }
}

struct ScreenTwo: Screen {
    var id: String { "screen.two" }
    let previous: Step
    
    init(previous: Step) {
        self.previous = previous
    }
    
    func goToScreenThree() -> ScreenThree {
        ScreenThree(previous: Step(action: .buttonTap(id: "nextTwo"), context: id, previous: previous))
    }
}

struct ScreenThree: Screen {
    var id: String { "screen.three" }
    let previous: Step
    
    init(previous: Step) {
        self.previous = previous
    }
    
    func dismiss() -> ScreenTwo {
        ScreenTwo(previous: Step(action: .buttonTap(id: "close"), context: id, previous: previous))
    }
}
