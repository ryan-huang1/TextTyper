import Cocoa
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "TextTyper"
            button.action = #selector(showMenu(_:))
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Type Text", action: #selector(typeText), keyEquivalent: "T"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))
        
        statusItem.menu = menu

        setupGlobalShortcut()
    }

    @objc func showMenu(_ sender: Any?) {
        // Show the menu
    }
    
    @objc func typeText() {
        typeCopiedText()
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
    
    func setupGlobalShortcut() {
        let shortcut = MASShortcut(keyCode: Int(kVK_ANSI_T), modifierFlags: [.command, .option])
        MASShortcutMonitor.shared().register(shortcut, withAction: {
            self.typeCopiedText()
        })
    }
    
    func typeCopiedText() {
        if let clipboardContent = NSPasteboard.general.string(forType: .string) {
            let source = CGEventSource(stateID: .hidSystemState)
            
            for char in clipboardContent {
                let keyCode = CGKeyCode(char.unicodeScalars.first!.value)
                let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true)
                let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false)
                keyDown?.post(tap: .cghidEventTap)
                keyUp?.post(tap: .cghidEventTap)
            }
        }
    }
}
