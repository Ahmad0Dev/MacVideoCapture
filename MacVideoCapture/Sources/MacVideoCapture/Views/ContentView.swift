import SwiftUI

struct ContentView: View {
    @StateObject private var captureManager = CaptureManager()
    @State private var isSettingsPresented = false
    @State private var isDevicesPresented = false
    @State private var isHelpPresented = false
    @State private var isFullscreen = false
    @AppStorage("currentLanguage") private var currentLanguage: Language = .english
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VideoPreviewView(session: captureManager.session)
                    .edgesIgnoringSafeArea(.all)
                
                if !isFullscreen {
                    ControlButtons(
                        isSettingsPresented: $isSettingsPresented,
                        isDevicesPresented: $isDevicesPresented,
                        isHelpPresented: $isHelpPresented,
                        currentLanguage: currentLanguage
                    )
                    .padding(.vertical, 10)
                }
            }
            
            Group {
                if isSettingsPresented {
                    SettingsPanel(
                        isPresented: $isSettingsPresented,
                        captureManager: captureManager,
                        currentLanguage: currentLanguage
                    )
                }
                if isDevicesPresented {
                    DevicePanel(
                        isPresented: $isDevicesPresented,
                        captureManager: captureManager,
                        currentLanguage: currentLanguage
                    )
                }
                if isHelpPresented {
                    HelpPanel(
                        isPresented: $isHelpPresented,
                        currentLanguage: currentLanguage
                    )
                }
            }
            .transition(.opacity)
        }
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 3 ||
                   event.keyCode == 53 && isFullscreen {
                    isFullscreen.toggle()
                    NSApp.windows.first?.toggleFullScreen(nil)
                    return nil
                }
                return event
            }
        }
    }
}
