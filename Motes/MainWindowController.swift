//
//  MainWindowController.swift
//  Motes
//
//  Created by Charlie on 2023/2/13.
//

import Cocoa

class MainWindowController: NSWindowController {
    static var shared: MainWindowController?
    var splitViewController: NSSplitViewController = NSSplitViewController()
    var sidebarViewController = SidebarViewController()
    var editorViewController = NSSplitViewController()
    lazy var textViewController = TextViewController()
    private final let windowMinWidth: CGFloat = 780
    private final let windowMinHeight: CGFloat = 600
    
    @IBAction func toggleSidebar(_ sender: Any) {
        if splitViewController.splitViewItems[0].isCollapsed {
            let sidebarWidth = splitViewController.splitViewItems[0].viewController.view.bounds.width
            let windowSize = window?.contentView?.bounds
            window?.contentMinSize = NSSize(width: windowSize!.width  - sidebarWidth, height: windowMinHeight)
            splitViewController.toggleSidebar(sender)
            window?.contentMinSize = NSSize(width: windowMinWidth, height: windowMinHeight)
        } else {
            splitViewController.toggleSidebar(sender)
        }
    }
    
    convenience init() {
        self.init(windowNibName: NSNib.Name(String(describing: Self.self)))
        MainWindowController.shared = self
        let previewController = NSViewController()
        previewController.view = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 0))
        editorViewController.addSplitViewItem(NSSplitViewItem(viewController: textViewController))
        editorViewController.addSplitViewItem(NSSplitViewItem(viewController: previewController))
        editorViewController.splitViewItems[0].canCollapse = true
        editorViewController.splitViewItems[1].canCollapse = true
        editorViewController.splitViewItems[1].isCollapsed = true
        
        splitViewController.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: sidebarViewController))
        splitViewController.addSplitViewItem(NSSplitViewItem(viewController: editorViewController))
        self.contentViewController = splitViewController
        window?.setContentSize(NSSize(width: windowMinWidth, height: windowMinHeight))
        window?.contentMinSize = NSSize(width: windowMinWidth, height: windowMinHeight)
        window?.backgroundColor = NSColor(named: "ToolbarBg")
        window?.toolbar?.items.first(where: { $0.itemIdentifier == .sidebar })?.view?.focusRingType = .none
        
        NSLayoutConstraint.activate([
            editorViewController.splitView.topAnchor.constraint(equalTo: splitViewController.splitView.topAnchor, constant: 38)
        ])
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    public func showWindow(force: Bool = false) {
        if force {
            super.showWindow(nil)
        }
    }
}

extension MainWindowController: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.flexibleSpace, .sidebarTrackingSeparator, .sidebar, .preview]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.sidebar, .sidebarTrackingSeparator, .preview]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
//        if itemIdentifier == .titlebar {
//            let item = NSToolbarItem(itemIdentifier: .titlebar)
//            item.autovalidates = true
//            item.isBordered = true
//
//            let item1 = NSPathControlItem()
//            let shadow = NSShadow()
//            shadow.shadowColor = NSColor.white
//            shadow.shadowBlurRadius = 1
//            item1.attributedTitle = .init(string: "rectangle.trailinghalf.inset.filled.arrow.trailing", attributes: [
//                .font: NSFont.systemFont(ofSize: 18),
//                .shadow: shadow,
//                .cursor: NSCursor.openHand as Any,
//            ])
//
//            let control = NSPathControl()
//            control.pathStyle = .standard
//            control.lineBreakMode = .byTruncatingMiddle
//            control.focusRingType = .none
//            control.action = #selector(click(_:))
//            control.pathItems = [item1]
//
//            item.view = control
//            return item
//        }
        if itemIdentifier == .preview {
            let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: [
                NSImage(systemSymbolName: "rectangle.leadinghalf.inset.filled", accessibilityDescription: nil)!.withSymbolConfiguration(.init(scale: .large))!,
                NSImage(systemSymbolName: "rectangle.split.2x1.fill", accessibilityDescription: nil)!.withSymbolConfiguration(.init(scale: .large))!,
                NSImage(systemSymbolName: "rectangle.trailinghalf.inset.filled", accessibilityDescription: nil)!.withSymbolConfiguration(.init(scale: .large))!,
            ], selectionMode: .selectOne, labels: [
                "Editor Only",
                "Split",
                "Preview Only"
            ], target: self, action: #selector(editorSplitClicked(_:)))
            item.selectedIndex = 0
            return item
        }
        return nil
    }
    
    @objc func editorSplitClicked(_ group: NSToolbarItemGroup?) {
        guard let index = group?.selectedIndex else { return }
        let textItem = editorViewController.splitViewItems[0]
        let previewItem = editorViewController.splitViewItems[1]
        if index == 0 {
            textItem.animator().isCollapsed = false
            previewItem.animator().isCollapsed = true
        } else if index == 1 {
            textItem.animator().isCollapsed = false
            previewItem.animator().isCollapsed = false
        } else {
            textItem.animator().isCollapsed = true
        }
    }
    
    @objc func click(_ sender: Any?) {
        print("titlebar clicked... \(String(describing: sender))")
    }
}

extension NSToolbarItem.Identifier {
    public static let sidebar = NSToolbarItem.Identifier("NSToolbarToggleSidebarItemIdentifier")
    public static let titlebar = NSToolbarItem.Identifier("titlebar")
    public static let preview = NSToolbarItem.Identifier("previewgroups")
}
