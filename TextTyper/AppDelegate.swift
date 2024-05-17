import Cocoa
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Configure the status bar button
        if let button = statusItem.button {
            button.title = "TextTyper"
            button.action = #selector(showMenu(_:))
        }
        
        // Create and configure the menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Type Text", action: #selector(typeText), keyEquivalent: "T"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))
        statusItem.menu = menu

        // Setup the global shortcut
        setupGlobalShortcut()
    }

    @objc func showMenu(_ sender: Any?) {
        // Show the menu (optional implementation)
    }
    
    @objc func typeText() {
        // Type the copied text
        typeCopiedText()
    }

    @objc func quitApp() {
        // Terminate the application
        NSApplication.shared.terminate(self)
    }
    
    func setupGlobalShortcut() {
        // Define the global shortcut (Command + Option + T)
        let shortcut = MASShortcut(keyCode: Int(kVK_ANSI_T), modifierFlags: [.command, .option])
        
        // Register the global shortcut and assign the action
        MASShortcutMonitor.shared().register(shortcut, withAction: { [weak self] in
            self?.typeCopiedText()
        })
    }
    
    func typeCopiedText() {
        // Retrieve the text from the clipboard
        if let clipboardContent = NSPasteboard.general.string(forType: .string) {
            // Log the clipboard content
            print("Clipboard content: \(clipboardContent)")
            
            let source = CGEventSource(stateID: .hidSystemState)
            
            // Type each character from the clipboard content
            for char in clipboardContent {
                if let unicodeScalar = char.unicodeScalars.first {
                    let keyCode = keyCodeForUnicodeScalar(unicodeScalar)
                    
                    if keyCode != UInt16.max {
                        // Log the character being typed
                        print("Typing character: \(char)")
                        
                        // Create and post key down event
                        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true)
                        keyDown?.post(tap: .cghidEventTap)
                        
                        // Create and post key up event
                        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false)
                        keyUp?.post(tap: .cghidEventTap)
                    }
                }
            }
        } else {
            // Log if clipboard is empty or not containing a string
            print("Clipboard is empty or does not contain a string")
        }
    }
    
    func keyCodeForUnicodeScalar(_ scalar: Unicode.Scalar) -> CGKeyCode {
        switch scalar {
        case "a": return 0
        case "b": return 11
        case "c": return 8
        case "d": return 2
        case "e": return 14
        case "f": return 3
        case "g": return 5
        case "h": return 4
        case "i": return 34
        case "j": return 38
        case "k": return 40
        case "l": return 37
        case "m": return 46
        case "n": return 45
        case "o": return 31
        case "p": return 35
        case "q": return 12
        case "r": return 15
        case "s": return 1
        case "t": return 17
        case "u": return 32
        case "v": return 9
        case "w": return 13
        case "x": return 7
        case "y": return 16
        case "z": return 6
        case "A": return 0
        case "B": return 11
        case "C": return 8
        case "D": return 2
        case "E": return 14
        case "F": return 3
        case "G": return 5
        case "H": return 4
        case "I": return 34
        case "J": return 38
        case "K": return 40
        case "L": return 37
        case "M": return 46
        case "N": return 45
        case "O": return 31
        case "P": return 35
        case "Q": return 12
        case "R": return 15
        case "S": return 1
        case "T": return 17
        case "U": return 32
        case "V": return 9
        case "W": return 13
        case "X": return 7
        case "Y": return 16
        case "Z": return 6
        case "0": return 29
        case "1": return 18
        case "2": return 19
        case "3": return 20
        case "4": return 21
        case "5": return 23
        case "6": return 22
        case "7": return 26
        case "8": return 28
        case "9": return 25
        case " ": return 49
        case ".": return 47
        case ",": return 43
        case "!": return 18
        case "?": return 44
        default: return UInt16.max
        }
    }
}
