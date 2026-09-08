//
//  StatusBarController.swift
//  Runner
//
//  Created by Darlington Onyemere on 05/09/2026.
//

import AppKit

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover

    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: 18.0)

        if let statusBarButton = statusItem.button {
            statusBarButton.image = #imageLiteral(resourceName: "AppIcon")
            statusBarButton.image?.size = NSSize(width: 18.0, height: 18.0)
            statusBarButton.image?.isTemplate = true
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
    }

    func showPopover(_ sender: AnyObject) {
        NSApp.activate(ignoringOtherApps: true)

        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
        popover.contentViewController?.view.window?.makeKey()
    }

    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }

    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {hidePopover(sender)}
        else {showPopover(sender)}
    }
}
