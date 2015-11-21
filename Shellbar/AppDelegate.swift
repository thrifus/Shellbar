//
//  Created by Patrick Hart on 11/17/15.
//  Copyright © 2015-2016 Patrick Hart. All rights reserved.
//

// SwiftLint
// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length

import Foundation
import Cocoa
import WebKit
import SwiftShell

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var view: NSView!
    @IBOutlet var aboutWebView: WebView!
    
    var urlpath = NSBundle.mainBundle().pathForResource("about", ofType: "html")
    
    func loadAddressURL() {
        let requesturl = NSURL(string: urlpath!)
        let request = NSURLRequest(URL: requesturl!)
        aboutWebView.mainFrame.loadRequest(request)
    }
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    
    // Notification Functions
    func ShowNotify() -> Void {
        let notification = NSUserNotification()
        notification.title = "Showing hidden files"
        notification.informativeText = "Finder will restart, and you'll probably notice it"
        notification.soundName = NSUserNotificationDefaultSoundName
        //notification.contentImage = NSImage(named: "StatusBarIcon")
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    func HideNotify() -> Void {
        let notification = NSUserNotification()
        notification.title = "Hiding hidden files"
        notification.informativeText = "Finder will restart, and you'll probably notice it"
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    // Show Hidden Files
    func ShowFiles(sender: AnyObject) {
        ShowNotify()
        run("defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder")
    }
    // Hide Hidden Files
    func HideFiles(sender: AnyObject) {
        HideNotify()
        run("defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder")
    }
    // Clear Logs
    func ClearLogs(sender: AnyObject) {
        //ClearLogsNotify()
        run("osascript -e 'do shell script \"sudo rm -fdrv /tmp/*; sudo rm -fdrv /var/tmp/*; sudo rm -fdrv /var/log/*; sudo rm -fdrv /private/tmp/*; sudo rm -fdrv /private/var/log/*\" with administrator privileges'")
    }
    // Empty Trash
    func EmptyTrash(sender: AnyObject) {
        //EmptyTrashNotify()
        run("osascript -e 'do shell script \"sudo rm -fdrv ~/.Trash/*\" with administrator privileges'")
    }
    // About Shellbar
    func AboutShellbar(sender: AnyObject) {
        self.window!.orderFront(self)
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
        loadAddressURL()
    }
    
    // NOTE: aNotificaton
    func applicationDidFinishLaunching(notification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarIcon")
        }
        
        if let button = statusItem.button {
        button.image = NSImage(named: "StatusBarIcon")
        button.action = Selector("AboutShellbar:")
        button.action = Selector("ShowFiles:")
        button.action = Selector("HideFiles:")
        button.action = Selector("ClearLogs:")
        button.action = Selector("EmptyTrash:")
        }
        
        let menu = NSMenu()
        // Menu Items
        menu.addItem(NSMenuItem(title: "About Shellbar", action: Selector("AboutShellbar:"), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Show Hidden Files", action: Selector("ShowFiles:"), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Hide Hidden Files", action: Selector("HideFiles:"), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Clear Logs", action: Selector("ClearLogs:"), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Empty Trash", action: Selector("EmptyTrash:"), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit Shellbar", action: Selector("terminate:"), keyEquivalent: ""))
        
        statusItem.menu = menu
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {}
}
