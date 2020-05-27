//
//  UILint.swift
//  UILint
//
//  Created by Quinn McHenry on 5/18/20.
//  Copyright © 2020 Quinn McHenry. All rights reserved.
//

import UIKit
import SimplePDF

public struct UILint {
    
    let elements: [QAElement]
    let findings: [QAFinding]
    let windowSize: CGSize
    let screenshot: UIImage?

    public init?(view: UIView) {
        guard let grandparent = view.parentViewController()?.view else {
            print("Unable to find parent view controller from view")
            return nil
        }
        
        var currentDepth = 0
                
        screenshot = grandparent.makeSnapshot()
        let windowSize = screenshot?.size ?? .zero

        func subviews(_ view: UIView) -> [UIView] {
            if let view = view as? UICollectionView {
                return view.visibleCells
            }
            return view.subviews
        }
        
        func recurse(_ view: UIView) -> [QAElement] {
            let viewOutput = [QAElement(view: view, depth: currentDepth)].compactMap{$0}
            currentDepth += 1
            return subviews(view).compactMap { recurse($0) }.reduce(viewOutput, +)
        }
        
        let elements = recurse(grandparent)
        findings = elements.flatMap { $0.findings(elements: elements, windowSize: windowSize) }
        self.elements = elements
        self.windowSize = windowSize
    }

    public func makePDF() -> Data {
        let pdf = SimplePDF(pageSize: CGSize(width: 850, height: 1100))
        
        if let screenshot = screenshot {
            pdf.addImage(screenshot)
        }
        
        findings.forEach { finding in
            pdf.beginHorizontalArrangement()
            pdf.addText(finding.severity.rawValue)
            pdf.addHorizontalSpace(10)
            pdf.addText(finding.message)
            pdf.endHorizontalArrangement()
            pdf.addLineSeparator(height: 0.1)
        }
        
        let pdfData = pdf.generatePDFdata()
        try? pdfData.write(to: URL(fileURLWithPath: "/tmp/test.pdf"), options: Data.WritingOptions.atomic)
        return pdfData
    }
}

