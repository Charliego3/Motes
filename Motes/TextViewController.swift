//
//  TextViewController.swift
//  Motes
//
//  Created by Charlie on 2023/3/11.
//

import Cocoa
import STTextView

class TextViewController: NSViewController {
    private var textView: STTextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = STTextView.scrollableTextView()
        textView = scrollView.documentView as? STTextView
        scrollView.backgroundColor = NSColor(named: "EditorBg")!
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.drawsBackground = true

        let paragraph = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraph.lineHeightMultiple = 1.1
        paragraph.defaultTabInterval = 28 // default

        textView.defaultParagraphStyle = paragraph
        textView.font = NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.textColor = NSColor(named: "TextColor")!
        textView.allowsUndo = true
        textView.selectionBackgroundColor = NSColor(named: "SelectBg")!

        textView.widthTracksTextView = true // wrap
        textView.highlightSelectedLine = true
        textView.textFinder.isIncrementalSearchingEnabled = true
        textView.textFinder.incrementalSearchingShouldDimContentView = true
        textView.delegate = self

        scrollView.documentView = textView

        // Line numbers
        let rulerView = STLineNumberRulerView(textView: textView)
        rulerView.allowsMarkers = false
        rulerView.highlightSelectedLine = true
        rulerView.textColor = .systemGray
        rulerView.selectedLineTextColor = NSColor(named: "TextColor")!
        rulerView.backgroundColor = NSColor(named: "EditorBg")!
        scrollView.verticalRulerView = rulerView
        scrollView.rulersVisible = true

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setString(_ string: String) {
        self.textView.string = string
    }

    @IBAction func toggleTextWrapMode(_ sender: Any?) {
        textView.widthTracksTextView.toggle()
    }

    @objc func removeAnnotation(_ annotationView: STAnnotationLabelView) {
        textView.removeAnnotation(annotationView.annotation)
    }
    
}

extension TextViewController: STTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        //
    }

    // Completion
    func textView(_ textView: STTextView, completionItemsAtLocation location: NSTextLocation) -> [Any]? {
        [
            STCompletion.Item(id: UUID().uuidString, label: "One", insertText: "one"),
            STCompletion.Item(id: UUID().uuidString, label: "Two", insertText: "two"),
            STCompletion.Item(id: UUID().uuidString, label: "Three", insertText: "three")
        ]
    }

    func textView(_ textView: STTextView, insertCompletionItem item: Any) {
        textView.insertText((item as! STCompletion.Item).insertText)
    }
}
