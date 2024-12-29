import SwiftUI
import AVFoundation

struct DevicePanel: View {
    @Binding var isPresented: Bool
    let captureManager: CaptureManager
    let currentLanguage: Language
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text(currentLanguage == .arabic ? "أجهزة الالتقاط" : "Capture Devices")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(ModernButtonStyle())
            }
            
            if captureManager.availableDevices.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "video.slash.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text(currentLanguage == .arabic ? "لا توجد أجهزة متاحة" : "No Devices Available")
                        .font(.headline)
                    Text(currentLanguage == .arabic ? "يرجى توصيل جهاز التقاط" : "Please connect a capture device")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                List(captureManager.availableDevices, id: \.uniqueID) { device in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(device.localizedName)
                                .font(.headline)
                            Text(device.manufacturer ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if device.uniqueID == captureManager.selectedDevice?.uniqueID {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        captureManager.selectDevice(device)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Spacer()
            
            Button(action: {
                captureManager.refreshDevices()
            }) {
                Label(
                    currentLanguage == .arabic ? "تحديث" : "Refresh",
                    systemImage: "arrow.clockwise"
                )
            }
            .buttonStyle(ModernButtonStyle())
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
