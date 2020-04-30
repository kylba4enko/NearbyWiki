//
//  RouteStepsPresenter.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 30.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

protocol RouteStepsPresenter {
    init(view: RouteStepsView, steps: [Step])
    func viewDidLoad()
    func stepsCount() -> Int
    func step(for index: Int) -> Step
}

final class RouteStepsPresenterImpl: RouteStepsPresenter {

    private weak var view: RouteStepsView?
    private let steps: [Step]

    required init(view: RouteStepsView, steps: [Step]) {
        self.view = view
        self.steps = steps
    }

    func viewDidLoad() {
        view?.showSteps()
    }

    func stepsCount() -> Int {
        steps.count
    }

    func step(for index: Int) -> Step {
        steps[index]
    }
}
