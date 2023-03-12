//
//  SidebarViewController.swift
//  Motes
//
//  Created by Charlie on 2023/2/13.
//

import Cocoa

class SidebarViewController: NSViewController {

    @IBOutlet weak var tabview: NSTabView!
    @IBOutlet weak var segments: NSSegmentedControl!
    var notesViewController = NotesViewController()
    lazy var favoritesViewController = FavoritesViewController()
    lazy var recentsViewController = RecentsViewController()
    lazy var trashViewController = TrashViewController()
    lazy var allNotesViewController = AllNotesViewController()
    private var lastSelectedSegment: Int = -1
    private let icons: [String] = ["folder", "star", "clock", "trash", "rectangle.on.rectangle.angled"]
    
    @IBAction func segmentClicked(_ sender: Any) {
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
        super.viewDidLoad()
        tabview.addTabViewItem(NSTabViewItem(viewController: notesViewController))
        tabview.addTabViewItem(NSTabViewItem(viewController: favoritesViewController))
        tabview.addTabViewItem(NSTabViewItem(viewController: recentsViewController))
        tabview.addTabViewItem(NSTabViewItem(viewController: trashViewController))
        tabview.addTabViewItem(NSTabViewItem(viewController: allNotesViewController))
        segmentClicked(segments as Any)
        NSLayoutConstraint.activate([
            self.view.widthAnchor.constraint(greaterThanOrEqualToConstant: 242),
            self.view.widthAnchor.constraint(lessThanOrEqualToConstant: (MainWindowController.shared?.window?.contentView?.bounds.width ?? 1200) / 2)
        ])
    }
    
}
