import SwiftUI

struct ModernButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(NSColor.controlBackgroundColor)
                    .opacity(configuration.isPressed ? 0.7 : 1))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ControlButtons: View {
    @Binding var isSettingsPresented: Bool
    @Binding var isDevicesPresented: Bool
    @Binding var isHelpPresented: Bool
    let currentLanguage: Language
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: { isDevicesPresented.toggle() }) {
                Label(currentLanguage == .arabic ? "الأجهزة" : "Devices",
                      systemImage: "video.fill")
            }
            Button(action: { isSettingsPresented.toggle() }) {
                Label(currentLanguage == .arabic ? "الإعدادات" : "Settings",
                      systemImage: "gear")
            }
            Button(action: { isHelpPresented.toggle() }) {
                Label(currentLanguage == .arabic ? "المساعدة" : "Help",
                      systemImage: "questionmark.circle")
            }
            Spacer()
            Button(action: { Language.current = currentLanguage == .english ? .arabic : .english }) {
                Label(currentLanguage == .arabic ? "English" : "عربي",
                      systemImage: "globe")
            }
        }
        .buttonStyle(ModernButtonStyle())
        .padding(.horizontal)
        .environment(\.layoutDirection, currentLanguage == .arabic ? .rightToLeft : .leftToRight)
    }
}
