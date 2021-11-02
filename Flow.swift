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

extension Screen {
    init() {
        self.init(previous: .start)
    }
    
    func segue<T: Screen>(action: Action) -> T {
        T(previous: Step(action: action, context: id, previous: previous))
    }

    func whenVisible() -> Self {
        Self(previous: Step(action: .view(id: id), context: id, previous: previous))
    }
}

enum Action {
    case view(id: String)
    case buttonTap(id: String)
}

indirect enum Step {
    case start
    case some(action: Action, context: String, previous: Step)

    init(action: Action, context: String, previous: Step) {
        self = .some(action: action, context: context, previous: previous)
    }
}
