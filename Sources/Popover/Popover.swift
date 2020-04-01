//
//  Popover.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//  Copyright © 2020 heavylightapps. All rights reserved.
//

import Cocoa

public class Popover: NSObject {
    enum PopoverPresentationMode {
        case undefined
        case image
        case customView
    }

    public var item: NSStatusItem!

    private var popoverWindowController: PopoverWindowController?
    private let windowConfiguration: PopoverConfiguration
    private var observation: NSKeyValueObservation?

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

    private func configureStatusBarButton(with image: NSImage) {
        image.isTemplate = true

        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = item.button else { return }

        button.target = self
        button.action = #selector(handleStatusItemButtonAction(_:))
        button.image = image
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
