//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 03.04.20.
//

import Cocoa

class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void

    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        guard let monitor = self.monitor else { return }

        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }
}
