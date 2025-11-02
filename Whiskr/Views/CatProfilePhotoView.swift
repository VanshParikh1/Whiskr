import SwiftUI
import UIKit
import AVFoundation


struct CatProfilePhotoView: View {
    @AppStorage("catProfileImage") private var storedImageData: Data?
    @State private var image: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false

    var body: some View {
        VStack {
            Image(uiImage: image ?? UIImage(named: "MeoLogo") ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.whiskred, lineWidth: 3))
                .shadow(radius: 5)

            Button("Change Photo") {
                showSourceOptions()
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.whiskred)
            .cornerRadius(8)
        }
        .onAppear {
            if let storedImageData,
               let uiImage = UIImage(data: storedImageData) {
                image = uiImage
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            PhotoLibraryPicker(image: $image, storedImageData: $storedImageData)
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraCaptureView(image: $image, storedImageData: $storedImageData, isPresented: $isShowingCamera)
        }
    }

    private func showSourceOptions() {
        let alert = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)

        // Camera option
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
            requestCameraAccess()
        })

        // Library option
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
            isShowingImagePicker = true
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(alert, animated: true)
        }
    }

    private func requestCameraAccess() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            isShowingCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.isShowingCamera = true
                    } else {
                        self.showCameraPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            showCameraPermissionAlert()
        @unknown default:
            showCameraPermissionAlert()
        }
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Access Needed",
            message: "Please enable camera access in Settings to take a new cat photo 🐱",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(alert, animated: true)
        }
    }
}

// Photo Library Picker (simple UIImagePickerController for library only)
struct PhotoLibraryPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var storedImageData: Data?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: PhotoLibraryPicker
        init(_ parent: PhotoLibraryPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.image = editedImage
                parent.storedImageData = editedImage.jpegData(compressionQuality: 0.9)
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.image = originalImage
                parent.storedImageData = originalImage.jpegData(compressionQuality: 0.9)
            }
            picker.dismiss(animated: true)
        }
    }
}

// Custom Camera View using AVCaptureSession
struct CameraCaptureView: View {
    @Binding var image: UIImage?
    @Binding var storedImageData: Data?
    @Binding var isPresented: Bool
    
    @StateObject private var camera = CameraModel()
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.whiskred)
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        camera.switchCamera()
                    }) {
                        Image(systemName: "camera.rotate")
                            .foregroundColor(.whiskred)
                            .font(.title2)
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        camera.capturePhoto { capturedImage in
                            if let capturedImage = capturedImage {
                                self.image = capturedImage
                                self.storedImageData = capturedImage.jpegData(compressionQuality: 0.9)
                                self.isPresented = false
                            }
                        }
                    }) {
                        Circle()
                            .fill(Color.whiskred)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 70, height: 70)
                            )
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            camera.startSession()
        }
        .onDisappear {
            camera.stopSession()
        }
    }
}

// Camera Preview View
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = camera.session
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        // Nothing needed here, PreviewView handles resizing
    }
}

// A custom UIView that always resizes its AVCaptureVideoPreviewLayer
class PreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        videoPreviewLayer.videoGravity = .resizeAspectFill
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        videoPreviewLayer.videoGravity = .resizeAspectFill
    }
}


// Camera Model to handle AVCaptureSession
class CameraModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    var preview: AVCaptureVideoPreviewLayer!
    var output = AVCapturePhotoOutput()
    var currentInput: AVCaptureDeviceInput?
    var isUsingFrontCamera = false
    
    private var captureCompletion: ((UIImage?) -> Void)?
    
    func startSession() {
        guard !session.isRunning else { return }
        
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        setupCamera()
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
        }
    }
    
    func stopSession() {
        guard session.isRunning else { return }
        session.stopRunning()
    }
    
    private func setupCamera() {
        let deviceType: AVCaptureDevice.DeviceType = .builtInWideAngleCamera
        let position: AVCaptureDevice.Position = isUsingFrontCamera ? .front : .back
        
        guard let device = AVCaptureDevice.default(deviceType, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        // Remove current input if exists
        if let currentInput = currentInput {
            session.removeInput(currentInput)
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
            currentInput = input
        }
    }
    
    func switchCamera() {
        session.beginConfiguration()
        isUsingFrontCamera.toggle()
        setupCamera()
        session.commitConfiguration()
    }
    
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        captureCompletion = completion
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

// Photo capture delegate
extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            captureCompletion?(nil)
            return
        }
        
        // Fix orientation for front camera
        let fixedImage = isUsingFrontCamera ? image.flippedHorizontally() : image
        captureCompletion?(fixedImage)
    }
}

// Extension to flip image horizontally
extension UIImage {
    func flippedHorizontally() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: size.width, y: 0)
        context.scaleBy(x: -1, y: 1)
        draw(at: .zero)
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return flippedImage
    }
}

#Preview {
    CatProfilePhotoView()
}
