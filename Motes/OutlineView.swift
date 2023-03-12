//
//  OutlineView.swift
//  Motes
//
//  Created by Charlie on 2023/2/15.
//

import Cocoa

class OutlineView: NSOutlineView {

    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        let view = super.makeView(withIdentifier: identifier, owner: owner)
        if identifier.rawValue == "NSOutlineViewDisclosureButtonKey" {
            view?.setBoundsOrigin(NSPoint(x: view?.bounds.origin.x ?? 0, y: 1.5))
        }
        return view
    }
    
}
