//
//  Popover.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//  Copyright © 2020 heavylightapps. All rights reserved.
//

import Cocoa

public class Popover: NSObject {
    private class StatusItemContainerView: NSView {
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
                y: (Constants.maxContainerSize-Constants.maxContentHeight) / 2,
                width: NSWidth(view.bounds),
                height: Constants.maxContentHeight
            )

            frame = selfFrame
            view.frame = contentFrame
        }
    }

    public var item: NSStatusItem!

    private var popoverWindowController: PopoverWindowController?
    private let windowConfiguration: PopoverConfiguration
    private var observation: NSKeyValueObservation?
    private var statusItemContainer: StatusItemContainerView?

    private var isPopoverWindowVisible: Bool {
        return (popoverWindowController != nil) ? popoverWindowController!.windowIsOpen : false
    }

    public init(with configuration: PopoverConfiguration) {
        windowConfiguration = configuration
    }

    public func presentPopover(with image: NSImage, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: image)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: windowConfiguration)
    }

    public func presentPopover(with view: NSView, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: view)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: windowConfiguration)
    }

    private func configureStatusBarButton(with image: NSImage) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = item.button else { return }

        image.isTemplate = true
        button.target = self
        button.action = #selector(handleStatusItemButtonAction(_:))
        button.image = image
    }

    private func configureStatusBarButton(with view: NSView) {
        item = NSStatusBar.system.statusItem(withLength: NSWidth(view.bounds))
        guard let button = item.button else { return }

        let statusItemContainer = StatusItemContainerView()

        button.target = self
        button.action = #selector(handleStatusItemButtonAction(_:))
        button.addSubview(statusItemContainer)

        statusItemContainer.embed(view)

        button.frame = statusItemContainer.frame
        self.statusItemContainer = statusItemContainer
    }

    @objc private func handleStatusItemButtonAction(_ sender: Any?) {
        if isPopoverWindowVisible {
            dismissPopoverWindow()
        } else {
            showPopoverWindow()
        }
    }

    public func dismissPopoverWindow() {
        popoverWindowController?.dismiss()
    }

    public func showPopoverWindow() {
        popoverWindowController?.show()
    }
}
