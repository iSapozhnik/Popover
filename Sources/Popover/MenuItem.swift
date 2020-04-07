//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 07.04.20.
//

import Foundation

public extension Popover {
    enum MenuItemType {
        case item(MenuItem)
        case separator
    }

    class MenuItem: NSObject {
        let title: String
        let key: String
        let _action: () -> Void

        public convenience init(title: String, action: @escaping () -> Void) {
            self.init(title: title, key: "", action: action)
        }

        public init(title: String, key: String, action: @escaping () -> Void) {
            self.title = title
            self.key = key
            _action = action
        }

        @objc
        func action() {
            _action()
        }
    }
}
