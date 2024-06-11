//
//  UIImage+Extensions.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import UIKit

extension UIImage {
    static func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
