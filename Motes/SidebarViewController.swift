//
//  SidebarViewController.swift
//  Motes
//
//  Created by Charlie on 2023/2/6.
//

import AppKit

class SidebarViewController: NSViewController {
    
    @IBOutlet weak var tabview: NSTabView!
    @IBOutlet weak var segments: NSSegmentedControl!
    private var lastSelectedSegment: Int = -1
    private let icons: [String] = ["folder", "star", "clock", "trash", "archivebox"]
    
    @IBAction func segmentChanged(_ sender: Any) {
        guard let control = sender as? NSSegmentedControl else { return }
        if lastSelectedSegment != control.selectedSegment {
            if lastSelectedSegment >= 0 {
                control.setImage(NSImage(systemSymbolName: icons[lastSelectedSegment], accessibilityDescription: nil), forSegment: lastSelectedSegment)
            }
            control.setImage(NSImage(systemSymbolName: icons[control.selectedSegment]+".fill", accessibilityDescription: nil), forSegment: control.selectedSegment)
        }
        tabview.selectTabViewItem(at: control.selectedSegment)
        lastSelectedSegment = control.selectedSegment
    }
    
    override func viewDidLoad() {
        NSLayoutConstraint.activate([
            tabview.widthAnchor.constraint(lessThanOrEqualToConstant: 600)
        ])
        tabview.addTabViewItem(NSTabViewItem(viewController: NotesViewController()))
        tabview.addTabViewItem(NSTabViewItem(viewController: FavoritesViewController()))
        tabview.addTabViewItem(NSTabViewItem(viewController: RecentsViewController()))
        tabview.addTabViewItem(NSTabViewItem(viewController: TrashViewController()))
        tabview.addTabViewItem(NSTabViewItem(viewController: AllNotesViewController()))
        segments.setSelected(true, forSegment: 0)
        segmentChanged(segments as Any)
    }
    
}
