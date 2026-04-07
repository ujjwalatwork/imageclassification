//
//  ContentView.swift
//  imageclassification
//
//  Created by Ujjwal Singh on 06/04/26.
//

import SwiftUI
import PhotosUI
import CoreML
import Vision

struct ContentView: View {
    @State private var imageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var result: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                VStack(spacing: 5) {
                    Text("Image Classifier")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Classify Image Using MobileNetV2")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.1))
                        .shadow(radius: 5)
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(20)
                    } else {
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Text("No Image Selected")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: 300)
                .padding(.horizontal)
                if !result.isEmpty {
                    VStack {
                        Text("\(result)")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                PhotosPicker(selection: $imageItem, matching: .images) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Select Image")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .onChange(of: imageItem) { _, newItem in
                    fetchImage(from: newItem)
                }
            }
        }
    }
    
    /// Get image from PhotosPickerItem
    private func fetchImage(from imageItem: PhotosPickerItem?) {
        guard let imageItem = imageItem else { return }
        Task {
            if let data = try? await imageItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                classifyImage(image: image)
                DispatchQueue.main.async {
                    selectedImage = image
                }
            }
        }
    }
    
    /// Image Classification
    ///
    private func classifyImage(image: UIImage) {
        guard let image = image.cgImage else { return }
        
        do {
            let modelConfig = MLModelConfiguration()
            let mobileNetModel = try MobileNetV2(configuration: modelConfig).model
            let coreMLModal = try VNCoreMLModel(for: mobileNetModel)
            let request = VNCoreMLRequest(model: coreMLModal) { (request, error) in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    let percentage = String(format: "%2.1f", topResult.confidence * 100)
                    DispatchQueue.main.async {
                        result = "\(topResult.identifier) (\(percentage)%)"
                    }
                }
            }
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            try handler.perform([request])
        } catch {
            result = error.localizedDescription
        }
    }
}

#Preview {
    ContentView()
}
