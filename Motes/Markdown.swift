//
//  Markdown.swift
//  Motes
//
//  Created by Charlie on 2023/2/15.
//

import Cocoa

class MarkdownModel: NSObject, ObservableObject {
    static let shared = MarkdownModel()
    @Published var markdowns: [Markdown] = []
    let allowedExt = ["md", "markdown"]
    
    func sortItems(_ items: [Markdown]) -> [Markdown] {
        return items.sorted {
            if ($0.directory && $1.directory) ||
                (!$0.directory && !$1.directory) {
                return $0.name < $1.name
            }
            return $0.directory || !$1.directory
        }
    }
    
    func initializeFiles(url: URL) {
        var files: [URL]? = Bookmarks.shared.access(url) { newURL in
            guard let files = try? FileManager.default.contentsOfDirectory(at: newURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) else {
                Utils.warningTerminate(message: "Failed to read the directory you selected: " + newURL.absoluteString)
                return nil
            }
            return files
        }
        if files == nil {
            files = []
        }
        
        markdowns.append(contentsOf: self.getFiles(files: files!))
        if markdowns.isEmpty { return }
        guard let first = markdowns.first else { return }
        guard let md = getFirst(first: first) else { return }
        guard let str = md.content() else { return }
        MainWindowController.shared?.textViewController.setString(str)
        MainWindowController.shared?.window?.title = md.name
    }
    
    private func getFirst(first: Markdown) -> Markdown? {
        if first.directory {
            guard let ch = first.children.first else { return nil }
            return getFirst(first: ch)
        }
        return first
    }
    
    private func getFiles(files: [URL]) -> [Markdown] {
        var items = [Markdown]()
        for fileURL in files {
            guard let attr = try? FileManager.default.attributesOfItem(atPath: fileURL.path) else {
                Utils.warningTerminate(message: "Failed to read file attributes: " + fileURL.absoluteString)
                continue
            }
            
            let ext = fileURL.pathExtension
            let directory = attr[.type] as? String == "NSFileTypeDirectory"
            if !directory && !allowedExt.contains(ext) {
                continue
            }
            
            let name = fileURL.deletingPathExtension().lastPathComponent
            let createAt = attr[.creationDate] as? Date
            let updateAt = attr[.modificationDate] as? Date
            var children: [Markdown] = []
            if directory {
                if let subFiles = try? FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) {
                    children.append(contentsOf: getFiles(files: subFiles))
                }
            }
            items.append(Markdown(name: name, url: fileURL, directory: directory, createAt: createAt, updateAt: updateAt, children: children))
        }
        return MarkdownModel.shared.sortItems(items)
    }
}

class Markdown: NSObject {
    let name: String
    let url: URL
    let directory: Bool
    let createAt: Date?
    let updateAt: Date?
    let children: [Markdown]
    
    convenience init(name: String, url: URL, directory: Bool, children: [Markdown] = [Markdown]()) {
        self.init(name: name, url: url, directory: directory, createAt: nil, updateAt: nil)
    }
    
    init(name: String, url: URL, directory: Bool, createAt: Date?, updateAt: Date?, children: [Markdown] = [Markdown]()) {
        self.name = name
        self.url = url
        self.directory = directory
        self.children = children
        self.createAt = createAt
        self.updateAt = updateAt
    }
    
    func tooltip() -> String {
        var tooltip = ""
        if let projectURL = Defaults.projectURL {
            let dir = url.deletingLastPathComponent().path.replacingOccurrences(of: projectURL.path, with: "")
            if !dir.isEmpty && name != dir {
                tooltip += " — \(dir.dropFirst())"
            }
        }
        return "\(name)\(tooltip)"
    }
    
    func content() -> String? {
        if self.directory { return nil }
        return Bookmarks.shared.access(self.url) { newURL in
            return (try? String(contentsOf: newURL, encoding: .utf8))
        }
    }
}
