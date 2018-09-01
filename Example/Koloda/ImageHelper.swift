//
//  JsonHelper.swift
//  Koloda_Example
//
//  Created by Ozkan Yilmaz on 1.09.2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyJSON

class ImageHelper {
    
    func getImageList(fromJson json: JSON) -> [Image] {
        var imageList = [Image]()
        
        let top_posts = json["graphql"]["hashtag"]["edge_hashtag_to_top_posts"]["edges"]
        for item in top_posts.arrayValue {
            if let image = getImageFrom(node: item) {
                imageList.append(image)
            }
        }
        
        let media = json["graphql"]["hashtag"]["edge_hashtag_to_media"]["edges"]
        for item in media.arrayValue {
            if let image = getImageFrom(node: item) {
                imageList.append(image)
            }
        }
        
        return imageList
    }
    
    private func getImageFrom(node: JSON) -> Image? {
        if node["node"]["is_video"].boolValue {
            return nil
        }
        
        let image = Image()
        image.url = node["node"]["display_url"].stringValue
        image.commentCount = node["node"]["edge_media_to_comment"]["count"].intValue
        image.likeCount = node["node"]["edge_liked_by"]["count"].intValue
        image.previewLikeCount = node["node"]["edge_media_preview_like"]["count"].intValue
        image.text = node["node"]["edge_media_to_caption"]["edges"][0]["node"]["text"].stringValue
        image.shortCode = node["node"]["shortcode"].stringValue
        
        return image
    }
    
    
}
