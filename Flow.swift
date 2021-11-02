//
//  Flow.swift
//  ContextAwareUITests
//
//  Created by Alex Manzella on 26/10/21.
//

import XCTest

protocol Screen {
    var id: String { get }
    var previous: Step { get }
    
    init(previous: Step)
}

struct Flow {
    let last: Step

    fileprivate init(last: Step) {
        self.last = last
    }
}

extension Screen {
    init() {
        self.init(previous: .start)
    }

    func whenVisible() -> Self {
        Self.init(previous: Step(action: .view(id: id), context: id, previous: previous))
    }
    
    func end() -> Flow {
        Flow(last: .end(last: previous))
    }
}

enum Action {
    case view(id: String)
    case buttonTap(id: String)
}

indirect enum Step {
    case start
    case some(action: Action, context: String, previous: Step)
    case end(last: Step)

    init(action: Action, context: String, previous: Step) {
        self = .some(action: action, context: context, previous: previous)
    }
}
