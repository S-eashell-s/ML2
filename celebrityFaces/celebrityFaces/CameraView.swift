//
//  CameraView.swift
//  celebrityFaces
//
//  Created by Shelly on 28/05/2025.
//

import SwiftUI
import AVFoundation
import Vision
import CoreML

struct CameraView: View {
    @Binding var showCamera: Bool
    @State private var result: String = "Analyzing..."
    @State private var celebImage: UIImage?
    @State private var shouldFlipCamera = false

    var body: some View {
        ZStack {
            CameraPreviewView(resultHandler: handleResult, shouldFlipCamera: $shouldFlipCamera)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: { showCamera = false }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Button(action: { shouldFlipCamera = true }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
                .padding()

                Spacer()

                VStack(spacing: 10) {
                    Text("You look most like")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(result)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    if let image = celebImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                    } else {
                        ProgressView("Loading image...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    }
                }
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(15)
                .padding(.bottom, 50)
            }
        }
    }

    func handleResult(_ prediction: String, _ image: UIImage?) {
        result = prediction
        celebImage = image
    }
}
