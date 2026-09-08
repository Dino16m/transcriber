import Cocoa
import FlutterMacOS
import ServiceManagement


@main
class AppDelegate: FlutterAppDelegate {
  var statusBar: StatusBarController?
  var popover = NSPopover.init()

  override init() {
    popover.behavior = NSPopover.Behavior.transient
    AppDelegate.alreadyRunningGuard()
  }
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }
  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ aNotification: Notification) {
    // uncomment the line below and the import statement
    // at the top to enable auto-launching on login
    // do {try SMAppService.mainApp.register()} catch {}

    let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    // popover.contentViewController = ctrl
    // popover.contentSize = NSSize(width: 360, height: 250)

    // statusBar = StatusBarController.init(popover)
    // mainFlutterWindow?.close()
    let channel = FlutterMethodChannel(name: "com.hiz.transcriber/text_injector", binaryMessenger: controller.engine.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call, result) in
        if call.method == "pasteText", let args = call.arguments as? [String: Any], let text = args["text"] as? String {
            self?.simulatePaste(text: text)
            result(nil)
        } else if call.method == "typeText", let args = call.arguments as? [String: Any], let text = args["text"] as? String {
            self?.simulateTyping(text: text)
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    super.applicationDidFinishLaunching(aNotification)

  }

  private func simulatePaste(text: String) {
      let pasteboard = NSPasteboard.general
      pasteboard.clearContents()
      pasteboard.setString(text, forType: .string)

      let source = CGEventSource(stateID: .combinedSessionState)

      // Virtual key codes: 0x37 = Command, 0x09 = 'v'
      let cmdDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true)
      let vDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
      vDown?.flags = .maskCommand
      let vUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
      vUp?.flags = .maskCommand
      let cmdUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)

      cmdDown?.post(tap: .cghidEventTap)
      vDown?.post(tap: .cghidEventTap)
      vUp?.post(tap: .cghidEventTap)
      cmdUp?.post(tap: .cghidEventTap)
  }

  private func simulateTyping(text: String) {
    print("Simulating")
    let source = CGEventSource(stateID: .combinedSessionState)

    for character in text {
      print("Printing character \(character)")
        let stringValue = String(character)
        let utf16Chars = Array(stringValue.utf16)

        // Create key-down event for the character
        if let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true) {
            keyDown.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            keyDown.post(tap: .cghidEventTap)
        }

        // Create key-up event for the character
        if let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false) {
            keyUp.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            keyUp.post(tap: .cghidEventTap)
        }

        // Optional micro-delay to prevent dropping characters in heavy text fields
        usleep(1000)
    }
}

  private static func alreadyRunningGuard() {
    let bundleID = Bundle.main.bundleIdentifier!
    let runCount = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID).count

    if runCount <= 1 {
      return
    }

    let a = NSAlert()
    a.messageText = "App already running"
    a.informativeText = "Another instance of this app is already running. Please close it first."
    a.addButton(withTitle: "OK")
    a.runModal()
    NSApp.terminate(nil)

  }
}