//
//  MvpViewController.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import UIKit

protocol MvpPresenter: AnyObject, DefaultInitializable {
    associatedtype View: MvpView where View.Presenter == Self

    var view: View? { get }

    init()

    func attachView(_ view: View)
    func detachView()
}

extension MvpPresenter {
    var isViewAttached: Bool {
        get { view != nil }
    }
}

protocol MvpView: AnyObject {
    associatedtype Presenter: MvpPresenter where Presenter.View == Self

    var presenter: Presenter? { get set }
}

extension MvpView {
    var isPresenterAttached: Bool {
        get { presenter != nil }
    }
}

class MvpViewController<Presenter: MvpPresenter>: UIViewController {
    var presenter: Presenter?

    deinit {
        presenter?.detachView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attachPresenterIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attachViewToPresenter()
    }
}

extension MvpViewController {
    func attachPresenterIfNeeded() {
        if presenter == nil {
            presenter = .init()
        }
    }

    func attachViewToPresenter() {
        guard
            let presenter = self.presenter,
            !presenter.isViewAttached,
            let view = self as? Presenter.View
        else { return }

        presenter.attachView(view)
    }
}
