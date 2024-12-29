import SwiftUI

@main
struct MacVideoCaptureApp: App {
    init() {
        if let window = NSApplication.shared.windows.first {
            window.styleMask.insert(.resizable)
            window.setContentSize(NSSize(width: 800, height: 600))
            window.minSize = NSSize(width: 640, height: 480)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.black)
                .frame(minWidth: 640, minHeight: 480)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandMenu("View") {
                Button("Toggle Fullscreen") {
                    NSApp.windows.first?.toggleFullScreen(nil)
                }
                .keyboardShortcut("f", modifiers: [.command, .shift])
            }
        }
    }
}
