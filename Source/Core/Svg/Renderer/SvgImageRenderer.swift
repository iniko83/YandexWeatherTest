//
//  SvgImageRenderer.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 13.07.2023.
//

import RxSwift
import WebKit

// NOTE: Based on - https://github.com/jonathanlu813/SVGWebRenderer

fileprivate typealias RenderError = SvgImageRenderError
fileprivate typealias RenderResult = Result<UIImage, Error>

protocol SvgImageRendererProtocol {
    func renderSvgImage(info: SvgImageInfo, data: Data) -> Single<UIImage>
}

extension SvgImageRenderer {
    typealias Info = SvgImageInfo
    typealias Name = SvgImageName

    fileprivate typealias Callback = (RenderResult) -> ()
    fileprivate typealias Task = RenderTask
}

final class SvgImageRenderer {
    private var callbacks = [Info: [Callback]]()

    private var pendingTasks = [Task]()
    private var taskExecutionCount = 0

    private var navigationDelegates = [Info: WebViewNavigationDelegate]()

    private var _containerView = UIView()
    private var isContainerViewInitialized = false

    private func getContainerView() throws -> UIView {
        guard !isContainerViewInitialized else {
            return _containerView
        }

        let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate else {
            throw RenderError.notFoundRenderContainerView
        }

        isContainerViewInitialized = true
        _containerView = delegate.svgRendererContainerView
        return _containerView
    }

    private func renderSvgImage(
        info: Info,
        data: Data,
        callback: @escaping Callback
    ) {
        let task = processingRenderRequest(
            info,
            data: data,
            callback: callback
        )

        guard let task else { return }

        pendingTasks.append(task)
        checkTaskQueue()
    }

    private func processingRenderRequest(
        _ info: Info,
        data: Data,
        callback: @escaping Callback
    ) -> Task? {
        var isTaskNeeded: Bool
        var callbacks: [Callback]
        if let renderCallbacks = self.callbacks.removeValue(forKey: info) {
            callbacks = renderCallbacks
            isTaskNeeded = false
        } else {
            callbacks = .init()
            isTaskNeeded = true
        }

        callbacks.append(callback)
        self.callbacks[info] = callbacks

        guard
            isTaskNeeded,
            let result = Task(info: info, data: data)
        else { return nil }

        return result
    }

    private func checkTaskQueue() {
        guard
            taskExecutionCount < .taskExecutionLimit,
            let task = pendingTasks.popLast()
        else { return }

        executeTask(task)
    }

    private func executeTask(_ task: Task) {
        let containerView: UIView
        do {
            containerView = try getContainerView()
        } catch {
            didFinishTask(task, result: .failure(error))
            return
        }

        taskExecutionCount += 1

        let info = task.info
        let size = task.size

        let navigationDelegate = WebViewNavigationDelegate(
            task: task,
            delegate: self
        )
        navigationDelegates[info] = navigationDelegate

        let frame = CGRect(size: size)
        let webView = WKWebView(frame: frame)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        containerView.addSubview(webView)
        webView.navigationDelegate = navigationDelegate
        webView.loadHTMLString(task.htmlString, baseURL: nil)
    }

    private func didFinishTask(_ task: Task, result: RenderResult) {
        taskExecutionCount -= 1
        checkTaskQueue()

        let info = task.info

        guard let renderCallbacks = callbacks.removeValue(forKey: info) else { return }

        for callback in renderCallbacks {
            callback(result)
        }
    }

    private func checkRenderResult(_ result: RenderResult, name: Name) throws {
        guard
            case .failure = result,
            case let .local(name) = name
        else { return }

        throw RenderError.failedRenderLocalSvg(name: name)
    }
}

extension SvgImageRenderer: SvgImageRendererProtocol {
    func renderSvgImage(info: Info, data: Data) -> Single<UIImage> {
        .create { [unowned self] observer in
            self.renderSvgImage(info: info, data: data) { renderResult in
                switch renderResult {
                case let .success(image):
                    observer(.success(image))
                case let .failure(error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - Private
private struct RenderTask {
    let info: SvgImageInfo

    let htmlString: String
    let size: CGSize

    init?(
        info: SvgImageInfo,
        data: Data
    ) {
        guard
            let string = String(data: data, encoding: .utf8),
            let size = string.parseOriginalSize(),
            let htmlString = string.buildHtmlString()
        else {
            return nil
        }

        self.info = info
        self.htmlString = htmlString

        let height = CGFloat(info.height)
        let aspectRatio = size.width / size.height
        let width = aspectRatio * height

        self.size = .init(width: width, height: height)
    }
}

private protocol RenderTaskDelegate: AnyObject {
    func didRenderTask(
        _ task: RenderTask,
        result: RenderResult,
        webView: WKWebView
    )
}

extension SvgImageRenderer: RenderTaskDelegate {
    fileprivate func didRenderTask(
        _ task: RenderTask,
        result: RenderResult,
        webView: WKWebView
    ) {
        webView.removeFromSuperview()

        let info = task.info
        let name = info.name

        navigationDelegates[info] = nil

        do {
            try checkRenderResult(result, name: name)
        } catch {
            didFinishTask(task, result: .failure(error))
            return
        }

        didFinishTask(task, result: result)
    }
}

private final class WebViewNavigationDelegate: NSObject {
    let task: RenderTask
    unowned let delegate: RenderTaskDelegate

    init(
        task: RenderTask,
        delegate: RenderTaskDelegate
    ) {
        self.task = task
        self.delegate = delegate
    }
}

extension WebViewNavigationDelegate: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .renderDelay) { [weak self] in
            guard let self else { return }

            let image = webView.snapshotImage()
            self.delegate.didRenderTask(
                self.task,
                result: .success(image),
                webView: webView
            )
        }
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation,
        withError error: Error
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.delegate.didRenderTask(
                task,
                result: .failure(error),
                webView: webView
            )
        }
    }
}

private extension String {
    func buildHtmlString() -> String? {
        guard let range = self.range(of: "<svg") else { return nil }

        let htmlStart = """
                        <HTML><STYLE>body { margin: 0 !important; padding: 0 !important; }</STYLE>
                        <HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>
                        """
        let htmlEnd = "</BODY></HTML>"
        let result = htmlStart
            + self[..<range.upperBound]
            + " width=\"100%\" height=\"100%\""
            + self[range.upperBound...]
            + htmlEnd

        return result
    }

    func parseOriginalSize() -> CGSize? {
        guard
            let lowerRange = range(of: "viewBox=\""),
            let upperRange = self[lowerRange.upperBound...].range(of: "\"")
        else { return nil }

        let viewbox = self[lowerRange.upperBound ..< upperRange.lowerBound]
        let values = viewbox.split(separator: " ")

        guard
            values.count == 4,
            let width = Int(values[2]),
            let height = Int(values[3])
        else { return nil }

        return .init(
            width: CGFloat(width),
            height: CGFloat(height)
        )
    }
}

// MARK: - Constants
private extension Int {
    static let taskExecutionLimit = 6
}

private extension TimeInterval {
    static let renderDelay = Self(1)
}
