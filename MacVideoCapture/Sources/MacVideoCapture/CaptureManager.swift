import Foundation
import AVFoundation

class CaptureManager: ObservableObject {
    @Published var availableDevices: [AVCaptureDevice] = []
    @Published var selectedDevice: AVCaptureDevice?
    @Published var isAutoMode = true
    @Published var selectedResolution: String = "1920x1080"
    @Published var selectedFrameRate: Int = 60
    
    let session = AVCaptureSession()
    private var input: AVCaptureDeviceInput?
    
    init() {
        refreshDevices()
    }
    
    func refreshDevices() {
        // Get available devices
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.externalUnknown],
            mediaType: .video,
            position: .unspecified
        )
        availableDevices = discoverySession.devices
        
        // Try to select the first device if none is selected
        if selectedDevice == nil, let firstDevice = availableDevices.first {
            selectDevice(firstDevice)
        }
    }
    
    func selectDevice(_ device: AVCaptureDevice) {
        // Remove existing input if any
        if let existingInput = input {
            session.removeInput(existingInput)
        }
        
        // Try to add new input
        do {
            session.beginConfiguration()
            
            // Create input
            let newInput = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
                input = newInput
                selectedDevice = device
                
                // Configure format based on settings
                configureFormat()
            }
            
            session.commitConfiguration()
            
            if !session.isRunning {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.session.startRunning()
                }
            }
        } catch {
            print("Error selecting device: \(error.localizedDescription)")
        }
    }
    
    func updateSettings() {
        configureFormat()
    }
    
    private func configureFormat() {
        guard let device = selectedDevice else { return }
        
        do {
            try device.lockForConfiguration()
            
            if isAutoMode {
                // In auto mode, use the highest resolution and frame rate available
                if let format = device.formats.max(by: { first, second in
                    let firstDimensions = CMVideoFormatDescriptionGetDimensions(first.formatDescription)
                    let secondDimensions = CMVideoFormatDescriptionGetDimensions(second.formatDescription)
                    return firstDimensions.width * firstDimensions.height < secondDimensions.width * secondDimensions.height
                }) {
                    device.activeFormat = format
                    
                    // Set highest frame rate
                    let maxFrameRate = format.videoSupportedFrameRateRanges.max(by: { $0.maxFrameRate < $1.maxFrameRate })?.maxFrameRate ?? 60
                    device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(maxFrameRate))
                }
            } else {
                // Parse selected resolution
                let components = selectedResolution.split(separator: "x")
                guard components.count == 2,
                      let width = Int(components[0]),
                      let height = Int(components[1]) else {
                    return
                }
                
                // Find matching format
                if let format = device.formats.first(where: { format in
                    let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
                    return dimensions.width == width && dimensions.height == height
                }) {
                    device.activeFormat = format
                    device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(selectedFrameRate))
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Error configuring device: \(error.localizedDescription)")
        }
    }
}
