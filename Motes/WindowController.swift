//
//  WindowController.swift
//  Motes
//
//  Created by Charlie on 2023/2/6.
//

import AppKit

class WindowController: NSWindowController {
    
    var splitViewController: NSSplitViewController?
    
    var toolbar: NSToolbar?
    
    override func windowDidLoad() {
        super.windowDidLoad()
//        self.contentViewController = splitViewController
        splitViewController = self.window?.contentViewController as? NSSplitViewController
//        splitViewController!.splitView(splitViewController!.splitView, constrainMinCoordinate: 600, ofSubviewAt: 0)
    }
}
