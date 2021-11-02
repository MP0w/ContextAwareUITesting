//
//  Flow+XCUITests.swift
//  ContextAwareUITests
//
//  Created by Alex Manzella on 26/10/21.
//

import XCTest

func verify(flow: Screen,
            app: XCUIApplication,
            timeout: TimeInterval = 0.5,
            retries: Int = 5) {
    var steps: [RawStep] = []
    var next: Step? = flow.previous

    while let current = next {
        switch current {
        case .start:
            next = nil
        case let .some(action, context, previous):
            next = previous
            steps.append(RawStep(action: action, context: context))
        }
    }
    
    verify(steps: steps.reversed(), app: app, step: 0, timeout: timeout, retries: retries)
}

private struct RawStep {
    let action: Action
    let context: String
}

private func verify(steps: [RawStep],
            app: XCUIApplication,
            step: Int,
            timeout: TimeInterval = 0.5,
            retries: Int) {

    let remainingSteps = steps[step..<steps.count]

    
    func retryIfPossible(failure: String) {
        guard retries > 0 else {
            XCTFail(failure)
            return
        }
        
        let currentId = currentScreenId(app: app)

        guard let retryStep = steps.indexOfFirstStep(for: currentId) else {
            XCTFail("I'm lost")
            return
        }
        
        verify(steps: steps, app: app, step: retryStep, timeout: timeout, retries: retries - 1)
    }
    
    for step in remainingSteps {
        switch step.action {
        case .buttonTap(let id):
            let button = app.buttons[id]
            if button.waitForExistence(timeout: timeout), button.isHittable {
                button.tap()
            } else {
                retryIfPossible(failure: "button not found \(id)")
                return
            }
        case .view(let id):
            if !app.otherElements[id].waitForExistence(timeout: timeout) {
                retryIfPossible(failure: "view not found \(id)")
                return
            }
        }
    }
}

private func currentScreenId(app: XCUIApplication) -> String {
    // TODO: better way to find out which screen you are, support alerts, etc..
    let predicate = NSPredicate(format: "identifier BEGINSWITH 'screen'")
    let elements = app.otherElements.matching(predicate)
    
    return elements.allElementsBoundByIndex[elements.count - 1].identifier
}


private extension Array where Element == RawStep {
    func indexOfFirstStep(for view: String) -> Int? {
        map { $0.context }.firstIndex { $0 == view }
    }
}
