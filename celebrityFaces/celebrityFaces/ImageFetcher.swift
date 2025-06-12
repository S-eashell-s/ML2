//
//  ImageFetcher.swift
//  celebrityFaces
//
//  Created by Shelly on 28/05/2025.
//

import Foundation
import UIKit

func fetchCelebrityImage(from name: String, completion: @escaping (UIImage?) -> Void) {
    let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
    let urlString = "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedName)"

    guard let url = URL(string: urlString) else {
        print("Invalid URL for \(name)")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let thumbnail = json["thumbnail"] as? [String: Any],
              let imageURLString = thumbnail["source"] as? String,
              let imageURL = URL(string: imageURLString),
              let imageData = try? Data(contentsOf: imageURL),
              let image = UIImage(data: imageData) else {
            print("No image found for \(name)")
            completion(nil)
            return
        }

        completion(image)
    }.resume()
}
