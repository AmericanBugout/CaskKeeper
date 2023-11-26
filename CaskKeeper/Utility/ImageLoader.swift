//
//  ImageLoader.swift
//  CaskKeeper
//
//  Created by Jon Oryhan on 11/25/23.
//

import SwiftUI
import Observation
import Combine

@Observable
class ImageLoader: ObservableObject {
    var image: Image?
    private var cancellables = Set<AnyCancellable>()
    
    // Define a cache for UIImage objects
    static let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from imageData: Data?, with identifier: UUID) {
        // If the image is already cached, use the cached version
        if let cachedImage = ImageLoader.imageCache.object(forKey: NSString(string: identifier.uuidString)) {
            self.image = Image(uiImage: cachedImage)
            return
        }
        
        guard let imageData = imageData else {
            self.image = nil // or set a default image
            return
        }
        
        // Perform the image loading in the background
        DispatchQueue.global(qos: .userInitiated).async {
            guard let uiImage = UIImage(data: imageData) else { return }
            
            // Cache the image
            ImageLoader.imageCache.setObject(uiImage, forKey: NSString(string: identifier.uuidString))
            
            // Switch back to the main thread to update the UI
            DispatchQueue.main.async { [weak self] in
                self?.image = Image(uiImage: uiImage)
            }
        }
    }
}
