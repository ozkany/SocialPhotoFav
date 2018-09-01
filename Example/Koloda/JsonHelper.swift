//
//  JsonHelper.swift
//  Koloda_Example
//
//  Created by Ozkan Yilmaz on 1.09.2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class JsonHelper {
    
    func getJson() {
        guard let url = URL(string: "https://www.instagram.com/explore/tags/beautifulgirl/?__a=1") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                
                ////
                //guard let firstData = dataResponse["graphql"]["hashtag"]["id"]? else { return }
                guard let jsonArray = jsonResponse as? [Any] else {
                    return
                }
                print(jsonArray)
                ////
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    
}
