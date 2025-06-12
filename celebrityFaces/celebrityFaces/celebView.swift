//
//  celebView.swift
//  celebrityFaces
//
//  Created by Shelly on 28/05/2025.
//

import SwiftUI
import AVFoundation
import CoreML
import Vision

struct celebView: View {
    @State private var showCamera = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var predictedName: String = ""
    @State private var celebImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        VStack(spacing: 20) {
            Text("What celebrity do you look most like?")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)

            Text("Open the camera or upload a photo to find out")
                .font(.subheadline)
                .bold()

            HStack(spacing: 40) {
                Button(action: {
                    showCamera = true
                }) {
                    Image(systemName: "camera")
                        .font(.system(size: 40))
                        .padding()
                        .background(Color.mint)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                Button(action: {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 40))
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)
            }

            if !predictedName.isEmpty {
                Text("You look most like")
                    .font(.headline)

                Text(predictedName)
                    .font(.title)
                    .fontWeight(.bold)

                if let celeb = celebImage {
                    Image(uiImage: celeb)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
        }
        .padding()
        .sheet(isPresented: $showCamera) {
            CameraView(showCamera: $showCamera)
        }
        .sheet(isPresented: $showImagePicker, onDismiss: handlePrediction) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
    }

    func handlePrediction() {
        guard let image = selectedImage,
              let ciImage = CIImage(image: image),
              let model = try? VNCoreMLModel(for: celebrityrecognition2(configuration: .init()).model) else { return }

        let request = VNCoreMLRequest(model: model) { request, _ in
            if let results = request.results as? [VNClassificationObservation], let top = results.first {
                DispatchQueue.main.async {
                    self.predictedName = top.identifier
                    fetchCelebrityImage(from: top.identifier) { fetchedImage in
                        DispatchQueue.main.async {
                            self.celebImage = fetchedImage
                        }
                    }
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
}
#Preview {
    celebView()
}
