//
//  CameraPreviewView.swift
//  celebrityFaces
//
//  Created by Shelly on 28/05/2025.
//

import UIKit
import SwiftUI
import AVFoundation
import Vision
import CoreML

struct CameraPreviewView: UIViewRepresentable {
    var resultHandler: (String, UIImage?) -> Void
    @Binding var shouldFlipCamera: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(resultHandler: resultHandler)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        context.coordinator.view = view
        context.coordinator.startCamera(in: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if shouldFlipCamera {
            context.coordinator.switchCamera()
            DispatchQueue.main.async {
                shouldFlipCamera = false
            }
        }
    }

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        private var session = AVCaptureSession()
        private var model: VNCoreMLModel?
        private var resultHandler: (String, UIImage?) -> Void
        private var currentCameraPosition: AVCaptureDevice.Position = .front
        private var previewLayer: AVCaptureVideoPreviewLayer?
        var view: UIView?

        init(resultHandler: @escaping (String, UIImage?) -> Void) {
            self.resultHandler = resultHandler
            super.init()
            if let mlModel = try? celebrityrecognition2(configuration: .init()).model {
                self.model = try? VNCoreMLModel(for: mlModel)
            }
        }

        func startCamera(in view: UIView) {
            session.beginConfiguration()
            session.sessionPreset = .photo

            for input in session.inputs {
                session.removeInput(input)
            }

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition),
                  let input = try? AVCaptureDeviceInput(device: device) else { return }

            if session.canAddInput(input) {
                session.addInput(input)
            }

            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            session.commitConfiguration()

            DispatchQueue.main.async {
                self.previewLayer?.removeFromSuperlayer()
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                self.previewLayer?.videoGravity = .resizeAspectFill
                self.previewLayer?.frame = view.bounds
                if let layer = self.previewLayer {
                    view.layer.insertSublayer(layer, at: 0)
                }
            }

            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }
        }

        func switchCamera() {
            guard let view = self.view else { return }
            currentCameraPosition = (currentCameraPosition == .front) ? .back : .front
            guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition),
                  let newInput = try? AVCaptureDeviceInput(device: newDevice) else { return }

            session.beginConfiguration()
            if let currentInput = session.inputs.first {
                session.removeInput(currentInput)
            }
            if session.canAddInput(newInput) {
                session.addInput(newInput)
            }
            session.commitConfiguration()

            DispatchQueue.main.async {
                self.previewLayer?.frame = view.bounds
            }
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer), let model = self.model else { return }
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNClassificationObservation], let top = results.first else { return }
                let label = top.identifier
                fetchCelebrityImage(from: label) { image in
                    DispatchQueue.main.async {
                        self.resultHandler(label, image)
                    }
                }
            }
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            try? handler.perform([request])
        }
    }
}
