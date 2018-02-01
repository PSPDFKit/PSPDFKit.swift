import Foundation
import PSPDFKit

public typealias RenderRequest = PSPDFRenderRequest
public typealias RenderType = PSPDFRenderType
public typealias RenderFilter = PSPDFRenderFilter

// Replaces original Objective-C `PSPDFRenderDrawBlock`. See https://bugs.swift.org/browse/SR-6873
public typealias PSPDFRenderDrawBlock = @convention(block) (_ context: CGContext, _ page: UInt, _ cropBox: CGRect, _ rotation: UInt, _ options: [String: Any]?) -> Void
public typealias RenderDrawHandler = PSPDFRenderDrawBlock

/// Rendering options. Parameters of how an image should be rendered.
public enum RenderOption: RawRepresentable, Codable {
    public typealias RawValue = [PSPDFRenderOption: Any]

    case none
    /// Changes the rendering to preserve the aspect ratio of the image.
    case preserveAspectRatio(Bool)
    /// Controls whether the image is forced to render with a scale of 1.0.
    case ignoreDisplaySettings(Bool)
    /// Multiplies a color used to color a page.
    case pageColor(UIColor)
    /// Inverts the rendering output.
    case inverted(Bool)
    /// Filters to be applied. Defaults to 0. Filters will increase rendering time.
    case filters(RenderFilter)
    /// Set custom interpolation quality.
    case interpolationQuality(CGInterpolationQuality)
    /// Set to true to NOT draw page content. (Use to just draw an annotation)
    case skipPageContent(Bool)
    /// Set to true to render annotations that have isOverlay = true set.
    case overlayAnnotations(Bool)
    /// Skip rendering of any annotations that are in this array.
    case skipAnnotations([PDFAnnotation])
    /// If true, will draw outside of page area.
    case ignorePageClip(Bool)
    /// Enabled/Disables antialiasing.
    case allowAntiAliasing(Bool)
    /// Allows custom render color. Default is white.
    case backgroundFillColor(UIColor)
    /// Controls if native text rendering via Core Graphics should be used.
    /// Native text rendering usually yields better results but is slower.
    case textRenderingUseCoreGraphics(Bool)
    /// Controls if ClearType is used for text rendering. Only works if
    /// `textRenderingUseCoreGraphics(Bool)` is set to false.
    case textRenderingClearTypeEnabled(Bool)
    /**
     Sets the interactive fill color, which will override the fill color for all newly
     rendered form elements that are editable.

     The interactive fill color is used if a form element is editable by the user to
     indicate that the user can interact with this form element.

     If this value is set, it will always be used if the element is editable and the
     `fillColor` specified by the PDF is ignored. Remove this key to use the fill color
     specified in the PDF.

     Defaults to a non-nil, light blue color.
     */
    case interactiveFormFillColor(UIColor)
    /// Allows custom content rendering after the PDF. The value for this key needs to be of type `RenderDrawHandler`.
    case draw(RenderDrawHandler)
    /// Controls if the "Sign here" overlay should be shown on unsigned signature fields.
    case drawSignHereOverlay(Bool)
    /// `CIFilter` that are applied to the rendered image before it is returned from the render pipeline.
    case ciFilters([CIFilter])

    public init?(rawValue: RawValue) {
        for (key, value) in rawValue {
            switch key {
            case .preserveAspectRatioKey:
                self = .preserveAspectRatio((value as? NSNumber)?.boolValue ?? false)
            case .ignoreDisplaySettingsKey:
                self = .ignoreDisplaySettings((value as? NSNumber)?.boolValue ?? false)
            case .pageColorKey:
                self = .pageColor(value as? UIColor ?? .white)
            case .invertedKey:
                self = .inverted((value as? NSNumber)?.boolValue ?? false)
            case .filtersKey:
                let rawValue = (value as? NSNumber)?.uintValue ?? .init(bitPattern: 0)
                self = .filters(RenderFilter(rawValue: rawValue))
            case .interpolationQualityKey:
                let qualityValue = CGInterpolationQuality(rawValue: (value as? NSNumber)?.int32Value ?? CGInterpolationQuality.default.rawValue)
                self = .interpolationQuality(qualityValue ?? CGInterpolationQuality.default)
            case .skipPageContentKey:
                self = .skipPageContent((value as? NSNumber)?.boolValue ?? false)
            case .overlayAnnotationsKey:
                self = .overlayAnnotations((value as? NSNumber)?.boolValue ?? false)
            case .skipAnnotationArrayKey:
                self = .skipAnnotations(value as? [PDFAnnotation] ?? [])
            case .ignorePageClipKey:
                self = .ignorePageClip((value as? NSNumber)?.boolValue ?? false)
            case .allowAntiAliasingKey:
                self = .allowAntiAliasing((value as? NSNumber)?.boolValue ?? false)
            case .backgroundFillColorKey:
                self = .backgroundFillColor(value as? UIColor ?? .black)
            case .textRenderingUseCoreGraphicsKey:
                self = .textRenderingUseCoreGraphics((value as? NSNumber)?.boolValue ?? false)
            case .textRenderingClearTypeEnabledKey:
                self = .textRenderingClearTypeEnabled((value as? NSNumber)?.boolValue ?? false)
            case .interactiveFormFillColorKey:
                self = .interactiveFormFillColor(value as? UIColor ?? .black)
            case .drawBlockKey:
                let closure: PSPDFRenderDrawBlock = unsafeBitCast(value, to: PSPDFRenderDrawBlock.self)
                self = .draw(closure)
            case .drawSignHereOverlay:
                self = .drawSignHereOverlay((value as? NSNumber)?.boolValue ?? false)
            case .ciFilterKey:
                self = .ciFilters(value as? [CIFilter] ?? [])
            default:
                fatalError("Unknown option")
            }
        }
        self = .none
    }

    public var rawValue: RawValue {
        switch self {
        case .none:
            return [:]
        case .preserveAspectRatio(let value):
            return [.preserveAspectRatioKey: NSNumber(value: value)]
        case .ignoreDisplaySettings(let value):
            return [.ignoreDisplaySettingsKey: NSNumber(value: value)]
        case .pageColor(let value):
            return [.pageColorKey: value]
        case .inverted(let value):
            return [.invertedKey: NSNumber(value: value)]
        case .filters(let filters):
            return [.filtersKey: filters]
        case .interpolationQuality(let value):
            return [.interpolationQualityKey: value.rawValue]
        case .skipPageContent(let value):
            return [.skipPageContentKey: NSNumber(value: value)]
        case .overlayAnnotations(let value):
            return [.overlayAnnotationsKey: NSNumber(value: value)]
        case .skipAnnotations(let annotations):
            return [.skipAnnotationArrayKey: annotations]
        case .ignorePageClip(let value):
            return [.ignorePageClipKey: NSNumber(value: value)]
        case .allowAntiAliasing(let value):
            return [.skipPageContentKey: NSNumber(value: value)]
        case .backgroundFillColor(let color):
            return [.backgroundFillColorKey: color]
        case .textRenderingUseCoreGraphics(let value):
            return [.skipPageContentKey: NSNumber(value: value)]
        case .textRenderingClearTypeEnabled(let value):
            return [.textRenderingClearTypeEnabledKey: NSNumber(value: value)]
        case .interactiveFormFillColor(let color):
            return [.interactiveFormFillColorKey: color]
        case .draw(let closure):
            return [.drawBlockKey: unsafeBitCast(closure, to: AnyObject.self)]
        case .drawSignHereOverlay(let value):
            return [.drawSignHereOverlay: NSNumber(value: value)]
        case .ciFilters(let filters):
            return [.ciFilterKey: filters]
        }
    }

    public init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        self.init(rawValue: try unkeyedContainer.decode(RawValue.self))!
    }

    public func encode(to encoder: Encoder) throws {
        var unkeyedContainer = encoder.unkeyedContainer()
        try unkeyedContainer.encode(self.rawValue)
    }
}

/// Covenience helpers to get values out of [RenderOption]
extension Array where Element == RenderOption {

    public var preserveAspectRatio: Bool {
        for option in self {
            if case .preserveAspectRatio(let value) = option {
                return value
            }
        }
        return false
    }

    public var ignoreDisplaySettings: Bool {
        for option in self {
            if case .ignoreDisplaySettings(let value) = option {
                return value
            }
        }
        return false
    }

    public var pageColor: UIColor? {
        for option in self {
            if case .pageColor(let color) = option {
                return color
            }
        }
        return nil
    }

    public var inverted: Bool {
        for option in self {
            if case .inverted(let value) = option {
                return value
            }
        }
        return false
    }

    public var filters: RenderFilter? {
        for option in self {
            if case .filters(let value) = option {
                return value
            }
        }
        return nil
    }

    public var interpolationQuality: CGInterpolationQuality? {
        for option in self {
            if case .interpolationQuality(let value) = option {
                return value
            }
        }
        return nil
    }

    public var skipPageContent: Bool {
        for option in self {
            if case .skipPageContent(let value) = option {
                return value
            }
        }
        return false
    }

    public var overlayAnnotations: Bool {
        for option in self {
            if case .overlayAnnotations(let value) = option {
                return value
            }
        }
        return false
    }

    public var ignorePageClip: Bool {
        for option in self {
            if case .ignorePageClip(let value) = option {
                return value
            }
        }
        return false
    }

    public var allowAntiAliasing: Bool {
        for option in self {
            if case .allowAntiAliasing(let value) = option {
                return value
            }
        }
        return false
    }

    public var backgroundFillColor: UIColor? {
        for option in self {
            if case .backgroundFillColor(let color) = option {
                return color
            }
        }
        return nil
    }

    public var textRenderingUseCoreGraphics: Bool {
        for option in self {
            if case .textRenderingUseCoreGraphics(let value) = option {
                return value
            }
        }
        return false
    }

    public var textRenderingClearTypeEnabled: Bool {
        for option in self {
            if case .textRenderingClearTypeEnabled(let value) = option {
                return value
            }
        }
        return false
    }

    public var interactiveFormFillColor: UIColor? {
        for option in self {
            if case .interactiveFormFillColor(let color) = option {
                return color
            }
        }
        return nil
    }

    public var draw: RenderDrawHandler? {
        for option in self {
            if case .draw(let handler) = option {
                return handler
            }
        }
        return nil
    }

    public var drawSignHereOverlay: Bool {
        for option in self {
            if case .drawSignHereOverlay(let value) = option {
                return value
            }
        }
        return false
    }

    public var ciFilters: [CIFilter] {
        for option in self {
            if case .ciFilters(let filters) = option {
                return filters
            }
        }
        return []
    }
}

internal class RenderRequestTests {
    static func test() throws {
        let document = PDFDocument()

        let drawClosure = { (_: CGContext, page: UInt, cropBox: CGRect, _: UInt, _: [String: Any]?) -> Void in
            let text = "PSPDF Live Watermark On Page \(page + 1)"
            let stringDrawingContext = NSStringDrawingContext()

            text.draw(with: cropBox, context: stringDrawingContext)
        }

        document.updateRenderOptions([.draw(drawClosure), .drawSignHereOverlay(true)], type: .all)
    }
}
