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
            .whenVisible()
        
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
        segue(action: .buttonTap(id: "next"))
    }
}

struct ScreenTwo: Screen {
    var id: String { "screen.two" }
    let previous: Step
    
    init(previous: Step) {
        self.previous = previous
    }
    
    func goToScreenThree() -> ScreenThree {
        segue(action: .buttonTap(id: "nextTwo"))
    }
}

struct ScreenThree: Screen {
    var id: String { "screen.three" }
    let previous: Step
    
    init(previous: Step) {
        self.previous = previous
    }
    
    func dismiss() -> ScreenTwo {
        segue(action: .buttonTap(id: "close"))
    }
}
