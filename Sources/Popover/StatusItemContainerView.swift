//
//  StatusItemContainerView.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 03.04.20.
//

import Cocoa

class StatusItemContainerView: NSView {
    enum Constants {
        static let maxContainerSize: CGFloat = 22.0
        static let maxContentHeight: CGFloat = 18.0
    }

    func embed(_ view: NSView) {
        addSubview(view)

        let selfFrame = NSRect(
            x: 0,
            y: 0,
            width: max(NSWidth(view.bounds), Constants.maxContainerSize),
            height: Constants.maxContainerSize
        )
        let contentFrame = NSRect(
            x: 0,
            y: (Constants.maxContainerSize - Constants.maxContentHeight) / 2,
            width: NSWidth(view.bounds),
            height: Constants.maxContentHeight
        )

        frame = selfFrame
        view.frame = contentFrame
    }
}
