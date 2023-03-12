//
//  Bookmark.swift
//  Motes
//
//  Created by Charlie on 2023/3/11.
//

import Cocoa

class Bookmarks {
    private var bookmarksPath = Bundle.main.url(forResource: "bookmarks", withExtension: "")!
    private var bookmarks: [URL: Data] = [:]
    public static var shared = Bookmarks()
    
    init() {
        do {
            let pathData = try Data(contentsOf: bookmarksPath)
            let marks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(pathData) as? [URL: Data]
            if marks != nil {
                bookmarks = marks!
            }
        } catch {
            print(error)
        }
    }
    
    func getBookmark(url: URL) -> Data? {
        if let data = bookmarks[url] {
            return data
        }
        
        do {
            let data = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            bookmarks[url] = data
            let archive = try NSKeyedArchiver.archivedData(withRootObject: bookmarks, requiringSecureCoding: false)
            try archive.write(to: bookmarksPath)
            return data
        } catch {
            print("saveBookmark error: \(error)")
        }
        return nil
    }
    
    func access<T>(_ url: URL, showWarning: Bool = true, terminate: Bool = true, _ fn: (URL) -> T?) -> T? {
        guard let data = getBookmark(url: url) else { return nil }
        var isState: Bool = false
        guard let newURL = (try? URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isState)) else {
            if showWarning {
                Utils.warningTerminate(message: "Failed to read: \(String(describing: url))", terminate: terminate)
            }
            return nil
        }
        if !newURL.startAccessingSecurityScopedResource() {
            if showWarning {
                Utils.warningTerminate(message: "Failed to read: \(String(describing: newURL))", terminate: terminate)
            }
            return nil
        }
        
        defer { newURL.stopAccessingSecurityScopedResource() }
        return fn(newURL)
    }
}
