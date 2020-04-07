//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 06.04.20.
//

import Cocoa

extension CAEdgeAntialiasingMask {
    static var all: CAEdgeAntialiasingMask {
        return [.layerLeftEdge, .layerRightEdge, .layerBottomEdge, .layerTopEdge]
    }
}

extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
