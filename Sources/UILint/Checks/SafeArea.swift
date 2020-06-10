//
//  SafeArea.swift
//  
//
//  Created by Quinn McHenry on 6/9/20.
//

import UIKit

public struct SafeArea: Check {
    public let description = "Adhere to the safe area and layout margins defined by UIKit."

    public func findings(forElement element: Element,
                         elements: [Element],
                         windowSize: CGSize,
                         safeAreaRect: CGRect,
                         screenshot: UIImage?) -> [Finding] {
        guard let windowFrame = element.base.windowFrame else { return [] }
        guard element.isLabel || element.isButton || element.isImage else { return [] }
        guard safeAreaRect.union(windowFrame) != safeAreaRect else { return [] }

        let message = "\(description)\n\(element.base.className) [\(windowFrame)] extends into safe area "
        + "[\(safeAreaRect)]"
        let croppedScreenshot = cropped(screenshot: screenshot, toWindowFrame: element.base.windowFrame)

        let finding = Finding(message: message, severity: .error,
                                screenshot: croppedScreenshot, element: element)
        return [finding]
    }

    public init() {}
}
