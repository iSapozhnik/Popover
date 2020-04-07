//
//  Popover.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 29.03.20.
//

import Cocoa

public class Popover: NSObject {
    var item: NSStatusItem! {
        didSet {
            prepareMenu()
        }
    }

    private let wConfig: PopoverConfiguration
    private var popoverWindowController: PopoverWindowController?
    private var globalEventMonitor: EventMonitor?
    private var localEventMonitor: EventMonitor?
    private var menu: NSMenu?
    private var menuItems: [MenuItemType]?

    private var isPopoverWindowVisible: Bool {
        return (popoverWindowController != nil) ? popoverWindowController!.windowIsOpen : false
    }

    /// Convenience initializer which is using default configuration
    public convenience override init() {
        self.init(with: DefaultConfiguration(), menuItems: nil)
    }

    /// Convenience initializer
    ///
    /// - Parameters:
    ///     - windowConfiguration: Popover window configuration. Subclass `DefaultConfiguration` and override properties or conform to `PopoverConfiguration` protocol.
    public convenience init(with windowConfiguration: PopoverConfiguration) {
        self.init(with: windowConfiguration, menuItems: nil)
    }

    /// Convenience initializer which is using default configuration and optiona menu items
    ///
    /// - Parameters:
    ///     - menuItems: Array of items that NSMenu will show
    public convenience init(with menuItems: [MenuItemType]?) {
        self.init(with: DefaultConfiguration(), menuItems: menuItems)
    }

    /// Creates a Popover with given PopoverConfiguration. Popover configuration can be either `DefaultConfiguration` or you can sublclass this class and override some of the properties.
    ///
    /// By default Popover is using Event Monitor and by doing left or right click ouside of the Popover's frame, the Popover will be automatically dismissed.
    ///
    /// - Parameters:
    ///     - windowConfiguration: Popover window configuration. By default `DefaultConfiguration` instance is being used.
    ///     - menuItems: Array of items that NSMenu will show
    public init(with windowConfiguration: PopoverConfiguration, menuItems: [MenuItemType]?) {
        wConfig = windowConfiguration
        self.menuItems = menuItems

        super.init()

        setupMonitors()
    }

    /// Creates a Popover with given image and contentViewController
    ///
    /// By default it won't present any Popover until the user clicks on status bar item
    public func prepare(with image: NSImage, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: image)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: wConfig)
        localEventMonitor?.start()
    }

    /// Creates a Popover with given view and contentViewController. The view's height will be scaled down to 18pt and also will be vertically aligned. The wdith can be any.
    ///
    /// By default it won't present any Popover until the user clicks on status bar item
    public func prepare(with view: NSView, contentViewController viewController: NSViewController) {
        configureStatusBarButton(with: view)
        popoverWindowController = PopoverWindowController(with: self, contentViewController: viewController, windowConfiguration: wConfig)
        localEventMonitor?.start()
    }

    /// Shows the Popover with no animation
    public func show() {
        guard !isPopoverWindowVisible else { return }
        popoverWindowController?.show()
        globalEventMonitor?.start()
    }

    /// Dismisses the Popover with default animation. Animation behavior is `AnimationBehavior.utilityWindow`
    public func dismiss() {
        guard isPopoverWindowVisible else { return }
        popoverWindowController?.dismiss()
        globalEventMonitor?.stop()
    }

    private func setupMonitors() {
        globalEventMonitor = EventMonitor(monitorType: .global, mask: [.leftMouseDown, .rightMouseDown], globalHandler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss()
        }, localHandler: nil)

        if menuItems != nil, menuItems?.isNotEmpty ?? false {
            localEventMonitor = EventMonitor(monitorType: .local, mask: [.leftMouseDown, .rightMouseDown], globalHandler: nil, localHandler: { [weak self] event -> NSEvent? in
                guard let self = self, let currentEvent = event else { return event }

                let isRightMouseClick = currentEvent.type == .rightMouseDown
                let isControlLeftClick = currentEvent.type == .leftMouseDown && currentEvent.modifierFlags.contains(.control)

                if isRightMouseClick || isControlLeftClick {
                    self.dismiss()
                    self.item.menu = self.menu
                }

                return event
            })
        }
    }

    private func configureStatusBarButton(with image: NSImage) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        guard let button = item.button else { return }

        image.isTemplate = true
        button.image = image
        setTargetAction(for: button)
    }

    private func configureStatusBarButton(with view: NSView) {
        item = NSStatusBar.system.statusItem(withLength: NSWidth(view.bounds))
        guard let button = item.button else { return }

        let statusItemContainer = StatusItemContainerView()

        setTargetAction(for: button)
        button.addSubview(statusItemContainer)

        statusItemContainer.embed(view)
    }

    @objc private func handleStatusItemButtonAction(_ sender: Any?) {
        isPopoverWindowVisible ? dismiss() : show()
    }

    private func setTargetAction(for button: NSButton) {
        button.target = self
        button.action = #selector(handleStatusItemButtonAction(_:))
    }

    private func prepareMenu() {
        guard menuItems != nil, menuItems?.isNotEmpty ?? false else { return }

        let menu = NSMenu()
        menuItems?.forEach { menuItemType in
            switch menuItemType {
            case .item(let actionItem):
                let menuItem = NSMenuItem(title: actionItem.title, action: #selector(MenuItem.action), keyEquivalent: actionItem.key)
                menuItem.target = actionItem
                menu.addItem(menuItem)
            case .separator:
                menu.addItem(NSMenuItem.separator())
            }
        }

        menu.delegate = self
        self.menu = menu
    }
}

extension Popover: NSMenuDelegate {
    public func menuDidClose(_ menu: NSMenu) {
        item.menu = nil
    }
}
