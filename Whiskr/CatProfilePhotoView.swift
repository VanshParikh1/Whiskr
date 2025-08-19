import SwiftUI
import UIKit

struct CatProfilePhotoView: View {
    @AppStorage("catProfileImage") private var storedImageData: Data?
    @State private var image: UIImage? = nil
    @State private var isShowingPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary

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
        .sheet(isPresented: $isShowingPicker) {
            ImagePicker(image: $image, storedImageData: $storedImageData, sourceType: pickerSource)
        }
    }

    private func showSourceOptions() {
        let alert = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
                pickerSource = .camera
                isShowingPicker = true
            })
        }

        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { _ in
            pickerSource = .photoLibrary
            isShowingPicker = true
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // Present the action sheet
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(alert, animated: true)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var storedImageData: Data?
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

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

#Preview {
    CatProfilePhotoView()
}
