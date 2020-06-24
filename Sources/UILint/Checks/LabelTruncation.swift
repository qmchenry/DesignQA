//
//  LabelTruncation.swift
//  
//
//  Created by Quinn McHenry on 6/8/20.
//

import UIKit

public struct LabelTruncation: Check {
    public let description = "Label text is truncated."

    public func findings<T: Element>(forElement element: T, elements: [T], context: LintingContext) -> [Finding] {
        guard let element = element as? Label, element.isLabelTruncated() else { return [] }
        // todo handle auto font scaling

        let explanation = "\(element.base.className) [\(element.base.depth)] full text is '\(element.text)' "
        let cropped = crop(screenshot: context.screenshot, toWindowFrame: element.base.windowFrame)
        let finding = Finding(description: description, explanation: explanation, severity: .error,
                              screenshot: cropped, element: element)
        return [finding]
    }

    public init() {}
}
