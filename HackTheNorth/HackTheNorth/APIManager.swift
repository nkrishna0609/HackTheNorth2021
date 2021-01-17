//
//  APIManager.swift
//  HackTheNorth
//
//  Created by Arjun Dureja on 2021-01-17.
//  Copyright © 2021 Arjun Dureja. All rights reserved.
//

import Foundation


class Item: Codable {
    var id: String
    var product_name: String
    var username: String
    var add_date: String
    var exp_date: String
    var preview_img_url: String
}

class APIManager {
    public static var username = ""
    
    public static var shared = APIManager()
    
    var apiURL = "http://10.0.0.152:5000/"
    
    func getAllItems(username: String, completion: @escaping ([Item]) -> ()) {
        let url = URL(string: apiURL + "getAllItems")!
        let jsonDict = ["username": username]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])

        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }

            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                let items = try decoder.decode([Item].self, from: data)
                completion(items)
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
    
    func uploadItem(username: String, srcImg: String, barcodeText: String, completion: @escaping (Bool) -> ()) {
        let url = URL(string: apiURL + "uploadItem")!
        let jsonDict = ["username": username, "src_img": srcImg, "barcode_text": barcodeText]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])

        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                completion(false)
                return
            }
            completion(true)
        }
        task.resume()
    }
}
