//
//  ImageManager.swift
//  secondhand
//
//  Created by 조호근 on 6/23/24.
//

import UIKit
import os

class ImageManager {
    static let shared = ImageManager()
    
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> String? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
                return fileName
            } catch {
                os_log(.error, "[ Error saveImageToDocumentsDirectory() ]: %@: - %@", fileURL.path, error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    func getImageURL(fileName: String) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
