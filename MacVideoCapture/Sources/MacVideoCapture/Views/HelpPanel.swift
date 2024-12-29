import SwiftUI

struct HelpPanel: View {
    @Binding var isPresented: Bool
    let currentLanguage: Language
    
    var body: some View {
        VStack(spacing: 20) {
            Text(currentLanguage == .arabic ? "تعليمات الاستخدام" : "Help")
                .font(.title)
                .padding(.top)
            
            VStack(alignment: .leading, spacing: 12) {
                KeyboardShortcutRow(
                    key: "⌘ + ⇧ + F",
                    description: currentLanguage == .arabic ? "تفعيل/إلغاء وضع ملء الشاشة" : "Toggle fullscreen mode"
                )
                KeyboardShortcutRow(
                    key: "ESC",
                    description: currentLanguage == .arabic ? "الخروج من وضع ملء الشاشة" : "Exit fullscreen mode"
                )
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("© 2024 AhmadDev")
                    .font(.headline)
                Text("X: @T8ne_")
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            Button(currentLanguage == .arabic ? "إغلاق" : "Close") {
                isPresented = false
            }
            .keyboardShortcut(.defaultAction)
            .padding(.bottom)
        }
        .frame(width: 400, height: 300)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 20)
    }
}

struct KeyboardShortcutRow: View {
    let key: String
    let description: String
    
    var body: some View {
        HStack {
            Text(key)
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(NSColor.tertiaryLabelColor).opacity(0.2))
                .cornerRadius(6)
            
            Text(description)
                .foregroundColor(.primary)
        }
    }
}
