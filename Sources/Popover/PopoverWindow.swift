//
//  PopoverWindow.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//

import Cocoa

class PopoverWindow: NSPanel {
    var arrowXLocation: CGFloat = 0.0 {
        didSet {
            updateArrowPosition()
        }
    }
    private let wConfig: PopoverConfiguration
    private var childContentView: NSView?
    private var backgroundView: PopoverWindowBackgroundView?

    private init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool,
        configuration: PopoverConfiguration
    ) {
        wConfig = configuration
        super.init(
            contentRect: contentRect,
            styleMask: style,
            backing: backingStoreType,
            defer: flag
        )

        isOpaque = false
        hasShadow = true
        level = .statusBar
        animationBehavior = .utilityWindow
        backgroundColor = .clear
        collectionBehavior = [.canJoinAllSpaces, .ignoresCycle]
        appearance = NSAppearance.current
    }

    static func window(with configuration: PopoverConfiguration) -> PopoverWindow {
        let window = PopoverWindow.init(
            contentRect: .zero,
            styleMask: [.nonactivatingPanel],
            backing: .buffered,
            defer: true,
            configuration: configuration
        )

        return window
    }

    override var canBecomeKey: Bool {
        return true
    }

    override var contentView: NSView? {
        set {
            guard childContentView != newValue, let bounds = newValue?.bounds else { return }

            backgroundView = super.contentView as? PopoverWindowBackgroundView
            if (backgroundView == nil) {
                backgroundView = PopoverWindowBackgroundView(frame: bounds, windowConfiguration: wConfig)
                backgroundView?.layer?.edgeAntialiasingMask = .all
                super.contentView = backgroundView
            }

            if (self.childContentView != nil) {
                self.childContentView?.removeFromSuperview()
            }

            childContentView = newValue
            childContentView?.translatesAutoresizingMaskIntoConstraints = false
            childContentView?.wantsLayer = true
            childContentView?.layer?.cornerRadius = wConfig.cornerRadius
            childContentView?.layer?.masksToBounds = true
            childContentView?.layer?.edgeAntialiasingMask = .all

            guard let userContentView = self.childContentView, let backgroundView = self.backgroundView else { return }
            backgroundView.addSubview(userContentView)

            let borderWidth = wConfig.borderColor != nil ? wConfig.borderWidth : 0
            let left = borderWidth + wConfig.contentEdgeInsets.left
            let right = borderWidth + wConfig.contentEdgeInsets.right
            let top = wConfig.arrowHeight + borderWidth + wConfig.contentEdgeInsets.top
            let bottom = borderWidth + wConfig.contentEdgeInsets.bottom

            NSLayoutConstraint.activate([
                userContentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: left),
                userContentView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -right),
                userContentView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: top),
                userContentView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -bottom)
            ])
        }

        get {
            childContentView
        }
    }

    override func frameRect(forContentRect contentRect: NSRect) -> NSRect {
        NSMakeRect(NSMinX(contentRect), NSMinY(contentRect), NSWidth(contentRect), NSHeight(contentRect) + wConfig.arrowHeight)
    }

    private func updateArrowPosition() {
        guard let backgroundView = self.backgroundView else { return }
        backgroundView.arrowXLocation = arrowXLocation
    }
}
