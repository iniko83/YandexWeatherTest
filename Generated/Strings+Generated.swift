// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum PresentableError {
    /// Connection lost.
    internal static let connectionLost = L10n.tr("Localizable", "PresentableError.ConnectionLost", fallback: "Connection lost.")
    /// Failed to parse data.
    internal static let decoding = L10n.tr("Localizable", "PresentableError.Decoding", fallback: "Failed to parse data.")
    /// Failed encoding data.
    internal static let encoding = L10n.tr("Localizable", "PresentableError.Encoding", fallback: "Failed encoding data.")
    /// Daily request limit exceeded.
    internal static let forbiddenRequest = L10n.tr("Localizable", "PresentableError.ForbiddenRequest", fallback: "Daily request limit exceeded.")
    /// Server maintenance.
    internal static let serverOffline = L10n.tr("Localizable", "PresentableError.ServerOffline", fallback: "Server maintenance.")
    /// Something went wrong.
    internal static let unknown = L10n.tr("Localizable", "PresentableError.Unknown", fallback: "Something went wrong.")
    /// Wrong request URL.
    internal static let wrongUrl = L10n.tr("Localizable", "PresentableError.WrongUrl", fallback: "Wrong request URL.")
  }
  internal enum SvgRenderError {
    /// Failed generate image for local svg with name "%@".
    internal static func failedRenderLocalSvg(_ p1: Any) -> String {
      return L10n.tr("Localizable", "SvgRenderError.FailedRenderLocalSvg", String(describing: p1), fallback: "Failed generate image for local svg with name \"%@\".")
    }
    /// Failed find containerView for render svg images.
    internal static let notFoundRenderContainerView = L10n.tr("Localizable", "SvgRenderError.NotFoundRenderContainerView", fallback: "Failed find containerView for render svg images.")
  }
  internal enum SvgResourceError {
    /// Please add "%@.svg" at "Resources/Icons" project folder.
    internal static func notFoundIcon(_ p1: Any) -> String {
      return L10n.tr("Localizable", "SvgResourceError.NotFoundIcon", String(describing: p1), fallback: "Please add \"%@.svg\" at \"Resources/Icons\" project folder.")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
