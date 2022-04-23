//
//  ImagePickerView.swift
//  Stock Jabber
//
//  Created by Pavan Maddineni on 11/01/22.
//  Copyright © 2022 sn99. All rights reserved.
//

import SwiftUI

public struct ImagePickerView: UIViewControllerRepresentable {
    
    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage,URL?) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage,URL?) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage,URL?) -> Void
        
        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage,URL?) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                
                var imageURL : URL? = nil
                if #available(iOS 11.0, *) {
                    if let imageURL1 = info[.imageURL] as? URL {
                        imageURL = imageURL1
                    }
                } else {
                    if let imageURL1 = info[.referenceURL] as? URL {
                        imageURL = imageURL1
                    }
                }
                
                if let finalImageUrl = imageURL {
                    
        let newImageUrl = MediaUtilities.shared.createAndMoveToImagesFolder(finalImageUrl)
                    self.onImagePicked(image,newImageUrl)
                }
                else{
                    let fileName = MediaUtilities.shared.createNewImageFileName()
                    let newImageUrl = MediaUtilities.shared.getImagesFileUrl(fileName)
                    MediaUtilities.shared.saveImageToDirectory(image, newImageUrl)
                    
                    self.onImagePicked(image,newImageUrl)
                }
                
            }
            self.onDismiss()
        }
        
        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }
        
    }
    
}
