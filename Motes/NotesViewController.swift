//
//  NotesViewController.swift
//  Motes
//
//  Created by Charlie on 2023/2/14.
//

import Cocoa

class NotesViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    lazy var folderImg = NSImage(systemSymbolName: "folder.fill", accessibilityDescription: nil)
    lazy var docImage = NSImage(systemSymbolName: "doc.text.image", accessibilityDescription: nil)
    private var currentMD: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doubleClick(_ sender: NSOutlineView) {
        let item = sender.item(atRow: sender.clickedRow)
        if item is Markdown {
            if sender.isItemExpanded(item) {
                sender.animator().collapseItem(item)
            } else {
                sender.animator().expandItem(item)
            }
        }
        
        guard let md = item as? Markdown else { return }
        if md.directory || md.url == currentMD { return }
        MainWindowController.shared?.window?.title = md.name
        guard let data = md.content() else { return }
        MainWindowController.shared?.textViewController.setString(data)
        currentMD = md.url
    }
    
    override func keyDown(with event: NSEvent) {
        interpretKeyEvents([event])
    }
    
    override func deleteBackward(_ sender: Any?) {
        let selectRow = outlineView.selectedRow
        if selectRow == -1 {
            return
        }
        
        print("deleteBackward: \(selectRow)")
    }
    
}

extension NotesViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let markdown = item as? Markdown {
            return markdown.children.count
        }
        return MarkdownModel.shared.markdowns.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let markdown = item as? Markdown {
            return markdown.children[index]
        }
        return MarkdownModel.shared.markdowns[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let markdown = item as? Markdown {
            return markdown.directory && markdown.children.count > 0
        }
        return false
    }
}

extension NotesViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        if let markdown = item as? Markdown {
            view = outlineView.makeView(withIdentifier: .init("NotesDataCell"), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                textField.stringValue = markdown.name
                textField.toolTip = markdown.tooltip()
                textField.sizeToFit()
            }
            if let image = view?.imageView {
                if markdown.directory {
                    image.image = self.folderImg
                } else {
                    image.image = self.docImage
                }
            }
        }
        return view
    }
}
