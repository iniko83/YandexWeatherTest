// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Action {
    /// Open settings
    internal static let openSettings = L10n.tr("Localizable", "Action.OpenSettings", fallback: "Open settings")
    internal enum Cancel {
      /// Cancel
      internal static let verb = L10n.tr("Localizable", "Action.Cancel.Verb", fallback: "Cancel")
    }
  }
  internal enum LocationServices {
    internal enum Warning {
      /// Location services available
      internal static let available = L10n.tr("Localizable", "LocationServices.Warning.Available", fallback: "Location services available")
      /// Location services denied
      internal static let denied = L10n.tr("Localizable", "LocationServices.Warning.Denied", fallback: "Location services denied")
    }
  }
  internal enum MoonPhase {
    internal enum Text {
      /// first quarter
      internal static let firstQuarter = L10n.tr("Localizable", "MoonPhase.Text.FirstQuarter", fallback: "first quarter")
      /// full moon
      internal static let fullMoon = L10n.tr("Localizable", "MoonPhase.Text.FullMoon", fallback: "full moon")
      /// last quarter
      internal static let lastQuarter = L10n.tr("Localizable", "MoonPhase.Text.LastQuarter", fallback: "last quarter")
      /// new moon
      internal static let newMoon = L10n.tr("Localizable", "MoonPhase.Text.NewMoon", fallback: "new moon")
      /// waning moon
      internal static let waningMoon = L10n.tr("Localizable", "MoonPhase.Text.WaningMoon", fallback: "waning moon")
      /// waxing crescent
      internal static let waxingCrescent = L10n.tr("Localizable", "MoonPhase.Text.WaxingCrescent", fallback: "waxing crescent")
    }
  }
  internal enum NetworkConnection {
    internal enum Warning {
      /// Connected
      internal static let connected = L10n.tr("Localizable", "NetworkConnection.Warning.Connected", fallback: "Connected")
      /// Network connection unavailable
      internal static let unavailable = L10n.tr("Localizable", "NetworkConnection.Warning.Unavailable", fallback: "Network connection unavailable")
    }
  }
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
  internal enum Text {
    /// No forecast
    internal static let noForecast = L10n.tr("Localizable", "Text.NoForecast", fallback: "No forecast")
    /// Today
    internal static let today = L10n.tr("Localizable", "Text.Today", fallback: "Today")
    /// Tomorrow
    internal static let tomorrow = L10n.tr("Localizable", "Text.Tomorrow", fallback: "Tomorrow")
  }
  internal enum Weather {
    internal enum BaseInfo {
      internal enum HeaderTitle {
        /// Feels like
        internal static let feelsLike = L10n.tr("Localizable", "Weather.BaseInfo.HeaderTitle.FeelsLike", fallback: "Feels like")
        /// mmHg
        internal static let pressure = L10n.tr("Localizable", "Weather.BaseInfo.HeaderTitle.Pressure", fallback: "mmHg")
        /// Temp
        internal static let temperature = L10n.tr("Localizable", "Weather.BaseInfo.HeaderTitle.Temperature", fallback: "Temp")
      }
    }
    internal enum Forecast {
      internal enum Identificator {
        internal enum HalfDay {
          internal enum Title {
            /// day
            internal static let day = L10n.tr("Localizable", "Weather.Forecast.Identificator.HalfDay.Title.Day", fallback: "day")
            /// night
            internal static let night = L10n.tr("Localizable", "Weather.Forecast.Identificator.HalfDay.Title.Night", fallback: "night")
          }
        }
        internal enum QuarterDay {
          internal enum Title {
            /// day
            internal static let day = L10n.tr("Localizable", "Weather.Forecast.Identificator.QuarterDay.Title.Day", fallback: "day")
            /// evening
            internal static let evening = L10n.tr("Localizable", "Weather.Forecast.Identificator.QuarterDay.Title.Evening", fallback: "evening")
            /// morning
            internal static let morning = L10n.tr("Localizable", "Weather.Forecast.Identificator.QuarterDay.Title.Morning", fallback: "morning")
            /// night
            internal static let night = L10n.tr("Localizable", "Weather.Forecast.Identificator.QuarterDay.Title.Night", fallback: "night")
          }
        }
      }
      internal enum Kind {
        /// Day & Night
        internal static let dayHalfs = L10n.tr("Localizable", "Weather.Forecast.Kind.DayHalfs", fallback: "Day & Night")
        /// Times of day
        internal static let dayQuarters = L10n.tr("Localizable", "Weather.Forecast.Kind.DayQuarters", fallback: "Times of day")
        /// Hourly
        internal static let hours = L10n.tr("Localizable", "Weather.Forecast.Kind.Hours", fallback: "Hourly")
      }
    }
  }
  internal enum WeatherController {
    internal enum Alert {
      internal enum LocationServicesDenied {
        /// To determine your current location, you need to turn on location services in the app's settings.
        internal static let message = L10n.tr("Localizable", "WeatherController.Alert.LocationServicesDenied.Message", fallback: "To determine your current location, you need to turn on location services in the app's settings.")
      }
    }
  }
  internal enum Wind {
    internal enum Direction {
      internal enum Short {
        /// c
        internal static let calm = L10n.tr("Localizable", "Wind.Direction.Short.Calm", fallback: "c")
        /// e
        internal static let east = L10n.tr("Localizable", "Wind.Direction.Short.East", fallback: "e")
        /// n
        internal static let north = L10n.tr("Localizable", "Wind.Direction.Short.North", fallback: "n")
        /// ne
        internal static let northEast = L10n.tr("Localizable", "Wind.Direction.Short.NorthEast", fallback: "ne")
        /// nw
        internal static let northWest = L10n.tr("Localizable", "Wind.Direction.Short.NorthWest", fallback: "nw")
        /// s
        internal static let south = L10n.tr("Localizable", "Wind.Direction.Short.South", fallback: "s")
        /// se
        internal static let southEast = L10n.tr("Localizable", "Wind.Direction.Short.SouthEast", fallback: "se")
        /// sw
        internal static let southWest = L10n.tr("Localizable", "Wind.Direction.Short.SouthWest", fallback: "sw")
        /// w
        internal static let west = L10n.tr("Localizable", "Wind.Direction.Short.West", fallback: "w")
      }
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
