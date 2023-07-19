//
//  Observable+LoadingState.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import RxSwift

extension ObservableType {
    func loadingState() -> Observable<LoadingState?> {
        materialize()
            .map { event -> LoadingState? in
                let result: LoadingState?
                if case let .error(error) = event {
                    let presentableError = PresentableError(error: error)
                    result = .error(presentableError)
                } else {
                    result = nil
                }
                return result
            }
            .startWith(.loading)
            .distinctUntilChanged()
    }
}
