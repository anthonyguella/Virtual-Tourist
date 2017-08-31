//
//  Flickr.swift
//  Virtual Tourist
//
//  Created by Anthony Guella on 8/23/17.
//  Copyright © 2017 Anthony Guella. All rights reserved.
//

import Foundation

class Flickr: NSObject {
    
    
    func getFlickrImagesFromSearch(lat: Double, lon: Double, page: Int = 1, _ totalPhotos: Int?, handler: @escaping(_ photos: [[String:AnyObject]]?, _ error: String?)->Void) {
        var p = page
        
        if totalPhotos != nil {
            if totalPhotos! > 4000 {
                p = Int(arc4random_uniform(4000/21)+1)
            } else {
                p = Int(arc4random_uniform(UInt32(totalPhotos!/21))+1)
            }
        }
        print(p)
        
        
        let parameters = [
            FlickrParameterKeys.Method: FlickrParameterValues.SearchMethod,
            FlickrParameterKeys.APIKey: FlickrParameterValues.APIKey,
            FlickrParameterKeys.SafeSearch: FlickrParameterValues.UseSafeSearch,
            FlickrParameterKeys.Extras: FlickrParameterValues.MediumURL,
            FlickrParameterKeys.Format: FlickrParameterValues.ResponseFormat,
            FlickrParameterKeys.NoJSONCallback: FlickrParameterValues.DisableJSONCallback,
            FlickrParameterKeys.BoundingBox: createBoundingBoxString(latitude: lat, longitude: lon),
            FlickrParameterKeys.PerPage: "21",
            FlickrParameterKeys.Page: String(p)
        ] as [String:AnyObject]
        
        let url = flickrURLFromParameters(parameters)
        
        let _ = NetworkConvenience.sharedInstance().taskForGetMethod(url: url) { (results, error) in
            
            guard error == nil else {
                handler(nil, "/(error)")
                return
            }
            
            guard let photoData = results!["photos"] as? [String : AnyObject] else {
                print("Can't find key 'photos'")
                handler(nil, "Wrong response")
                return
            }

            guard let totalNumPhotos = photoData["total"] as? String else {
                print("Can't find [photos][total] in response")
                handler(nil, "Wrong response")
                return
            }
            
            guard let results = photoData["photo"] as? [[String : AnyObject]] else {
                print("Can't find [photos][photo] in response")
                handler(nil, "Wrong response")
                return
            }
            
            if totalPhotos != nil {
                handler(results, nil)
            } else {
                self.getFlickrImagesFromSearch(lat: lat, lon: lon, Int(totalNumPhotos), handler: handler)
            }
        }
        
    }
    
    
    private func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func createBoundingBoxString(latitude: Double, longitude: Double) -> String {
        
        let BOUNDING_BOX_HALF_WIDTH = 1.0
        let BOUNDING_BOX_HALF_HEIGHT = 1.0
        let LAT_MIN = -90.0
        let LAT_MAX = 90.0
        let LON_MIN = -180.0
        let LON_MAX = 180.0
        
        let bottom_left_lon = max(longitude - BOUNDING_BOX_HALF_WIDTH, LON_MIN)
        let bottom_left_lat = max(latitude - BOUNDING_BOX_HALF_HEIGHT, LAT_MIN)
        let top_right_lon = min(longitude + BOUNDING_BOX_HALF_HEIGHT, LON_MAX)
        let top_right_lat = min(latitude + BOUNDING_BOX_HALF_HEIGHT, LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> Flickr {
        struct Singleton {
            static var sharedInstance = Flickr()
        }
        return Singleton.sharedInstance
    }
}
