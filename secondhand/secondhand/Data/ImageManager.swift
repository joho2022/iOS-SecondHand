//
//  ImageManager.swift
//  secondhand
//
//  Created by 조호근 on 6/23/24.
//

import UIKit
import os

class ImageManager: ImageSavingProtocol {
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> String? {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: tempURL)
                print(tempURL.path)
                return fileName
            } catch {
                os_log(.error, "[ Error saveImageToDocumentsDirectory() ]: %@: - %@", tempURL.path, error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    static func getImageURL(fileName: String) -> URL? {
        let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        return tempDirectory.appendingPathComponent(fileName)
    }
}
