//
//  ImageSavingProtocol.swift
//  secondhand
//
//  Created by 조호근 on 7/4/24.
//
import UIKit

protocol ImageSavingProtocol {
    func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> String?
}
