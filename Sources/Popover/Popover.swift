//
//  Popover.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//

import Cocoa

public class Popover: NSObject {
    var item: NSStatusItem!

    private let windowConfiguration: PopoverConfiguration
    private var popoverWindowController: PopoverWindowController?
    private var statusItemContainer: StatusItemContainerView?
    private var eventMonitor: EventMonitor?

    private var isPopoverWindowVisible: Bool {
        return (popoverWindowController != nil) ? popoverWindowController!.windowIsOpen : false
    }

    public init(with configuration: PopoverConfiguration) {
        windowConfiguration = configuration

        super.init()

        eventMonitor = EventMonitor(mask: [.rightMouseDown, .leftMouseDown], handler: { [weak self] event in
            guard let self = self else { return }
            self.dismissPopoverWindow()
        })
    }

    public func presentPopover(with image: NSImage, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: image)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: windowConfiguration)
    }

    public func presentPopover(with view: NSView, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: view)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: windowConfiguration)
    }

    public func showPopoverWindow() {
        popoverWindowController?.show()
        eventMonitor?.start()
    }

    public func dismissPopoverWindow() {
        popoverWindowController?.dismiss()
        eventMonitor?.stop()
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
}
