import SwiftUI
import AVFoundation

struct SettingsPanel: View {
    @Binding var isPresented: Bool
    @ObservedObject var captureManager: CaptureManager
    let currentLanguage: Language
    
    @AppStorage("isAutoMode") private var isAutoMode = false
    @AppStorage("selectedResolution") private var selectedResolution = "1920x1080"
    @AppStorage("selectedFrameRate") private var selectedFrameRate = 60
    
    private let availableResolutions = ["3840x2160", "2560x1440", "1920x1080", "1280x720"]
    private let availableFrameRates = [144, 120, 60, 30]
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(currentLanguage == .arabic ? "الإعدادات" : "Settings")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(ModernButtonStyle())
            }
            
            // Settings Content
            VStack(alignment: .leading, spacing: 16) {
                // Auto Mode
                Toggle(isOn: $isAutoMode) {
                    Text(currentLanguage == .arabic ? "الوضع التلقائي" : "Auto Mode")
                        .font(.headline)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .onChange(of: isAutoMode) { _ in
                    captureManager.updateSettings()
                }
                
                if !isAutoMode {
                    // Resolution
                    VStack(alignment: .leading, spacing: 8) {
                        Text(currentLanguage == .arabic ? "الدقة" : "Resolution")
                            .font(.headline)
                        Picker("", selection: $selectedResolution) {
                            ForEach(availableResolutions, id: \.self) { resolution in
                                Text(resolution).tag(resolution)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedResolution) { _ in
                            captureManager.updateSettings()
                        }
                    }
                    
                    // Frame Rate
                    VStack(alignment: .leading, spacing: 8) {
                        Text(currentLanguage == .arabic ? "معدل الإطارات" : "Frame Rate")
                            .font(.headline)
                        Picker("", selection: $selectedFrameRate) {
                            ForEach(availableFrameRates, id: \.self) { rate in
                                Text("\(rate) FPS").tag(rate)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedFrameRate) { _ in
                            captureManager.updateSettings()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(20)
        .frame(width: 400, height: 300)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(NSColor.windowBackgroundColor))
                .shadow(color: Color.black.opacity(0.2), radius: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
