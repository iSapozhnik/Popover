//
//  EventMonitor.swift
//  Popover
//
//  Created by Ivan Sapozhnik on 03.04.20.
//

import Cocoa

class EventMonitor {
    typealias GlobalEventHandler = (NSEvent?) -> Void
    typealias LocalEventHandler = (NSEvent?) -> NSEvent?

    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let globalHandler: GlobalEventHandler?
    private let localHandler: LocalEventHandler?

    init(mask: NSEvent.EventTypeMask, globalHandler: GlobalEventHandler?, localHandler: LocalEventHandler?) {
        self.mask = mask
        self.globalHandler = globalHandler
        self.localHandler = localHandler
    }

    deinit {
        stop()
    }

    func startGlobalMonitor() {
        guard let handler = globalHandler else {
            assertionFailure("Global event handler is not set.")
            return
        }
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func startLocalMonitor() {
        guard let handler = localHandler else {
            assertionFailure("Local event handler is not set.")
            return
        }
        monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        guard let monitor = self.monitor else { return }

        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }
}
