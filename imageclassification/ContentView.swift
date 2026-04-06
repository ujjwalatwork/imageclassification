//
//  ContentView.swift
//  imageclassification
//
//  Created by Ujjwal Singh on 06/04/26.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var imageItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
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
                
                VStack {
                    Text("Results will be shown here")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text("Results will be shown here")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text("Results will be shown here")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
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
                    print("Get net itme")
                    fetchImage(from: newItem)
                }
            }
        }
    }
    
    /// Get image from PhotosPickerItem
    func fetchImage(from imageItem: PhotosPickerItem?) {
        guard let imageItem = imageItem else { return }
        Task {
            if let data = try? await imageItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    selectedImage = image
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
