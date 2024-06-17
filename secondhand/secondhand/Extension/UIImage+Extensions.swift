//
//  UIImage+Extensions.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import UIKit

enum ImageLoadingError: Error {
    case invalidURL
    case networkError(Error)
    case invalidImageData
}

extension UIImage {
    static func loadImage(from urlString: String, completion: @escaping (Result<UIImage, ImageLoadingError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(.invalidImageData))
                return
            }
            
            completion(.success(image))
        }
        task.resume()
    }
}
