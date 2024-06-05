//
//  JusoService.swift
//  secondhand
//
//  Created by 조호근 on 6/5/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case jsonEncodingFailed
    case jsonDecodingFailed
    case noData
    case invalidResponse(Int)
    case unauthorized
    case networkFailed(Error)
    case serverError(String)
}

class JusoService {
    let baseURL = "https://business.juso.go.kr/addrlink/addrLinkApi.do"
    let confmKey = "devU01TX0FVVEgyMDI0MDYwNDIzMzM1NzExNDgyMzA="
    
    func fetchRoadAddresses(keyword: String, page: Int, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "confmKey", value: confmKey),
            URLQueryItem(name: "currentPage", value: "\(page)"),
            URLQueryItem(name: "countPerPage", value: "20"),
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "resultType", value: "json")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkFailed(error)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse(httpResponse.statusCode)))
                return
            }
            
            do {
                let jusoResponse = try JSONDecoder().decode(JusoResponse.self, from: data)
                print(jusoResponse)
                let common = jusoResponse.results.common
                if common.errorCode != "0" {
                    completion(.failure(.serverError("\(common.errorCode): \(common.errorMessage)")))
                } else {
                    let readAddresses = jusoResponse.results.juso.map { $0.roadAddr }
                    completion(.success(readAddresses))
                }
            } catch {
                completion(.failure(.jsonDecodingFailed))
            }
        }
        
        task.resume()
    }
}
