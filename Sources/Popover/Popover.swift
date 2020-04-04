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

    /// Create a Popover with given PopoverConfiguration. Popover configuration can be either `DefaultConfiguration` or you can sublclass this class and override some of the properties.
    /// By default Popover is using Event Monitor and by doing left or right clicl ouside of the Popover's frame, the system will automatically dismiss the Popover.
    public init(with configuration: PopoverConfiguration) {
        windowConfiguration = configuration

        super.init()

        eventMonitor = EventMonitor(mask: [.rightMouseDown, .leftMouseDown], handler: { [weak self] event in
            guard let self = self else { return }
            self.dismiss()
        })
    }

    /// Creates a Popover with given image and contentViewController
    /// By default it won't present any Popover until the user clicks on status bar item
    public func createPopover(with image: NSImage, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: image)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: windowConfiguration)
    }

    /// Creates a Popover with given view and contentViewController. The view's height will be scaled down to 18pt and also will be vertically aligned. The wdith can be any.
    /// By default it won't present any Popover until the user clicks on status bar item
    public func createPopover(with view: NSView, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: view)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: windowConfiguration)
    }

    /// Shows the Popover with no animation
    public func show() {
        popoverWindowController?.show()
        eventMonitor?.start()
    }

    /// Dismisses the Popover with default animation. Animation behaviour is `AnimationBehavior.utilityWindow`
    public func dismiss() {
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
            dismiss()
        } else {
            show()
        }
    }
}
