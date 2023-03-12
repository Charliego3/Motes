//
//  Utils.swift
//  Motes
//
//  Created by Charlie on 2023/3/11.
//

import Cocoa

class Utils {
    public static func warningTerminate(message: String, terminate: Bool = true) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Oops!"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
        if terminate {
            NSApplication.shared.terminate(nil)
        }
    }
}
