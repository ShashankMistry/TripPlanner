//
//  ImageList.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/6/22.
//

import UIKit

enum ImagesResult {
    case success([Image])
    case failure(Error)
}

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum ImgErr : Error {
    case photoCreationError
}

enum JSONError: Error {
    case invalidJSONData
}


class ImageList {
    var result : ImagesResult!
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    var urlStr = "";
    func setLocation(location: String){
        urlStr =  "https://api.pexels.com/v1/search?query=\(location)"
    }
    
    func getJSONResponseOfImages(completion: @escaping(ImagesResult)->Void ) {
        let urlComp = URLComponents(string: urlStr.replacingOccurrences(of: " ", with: "+"))
        let url = urlComp!.url
        var urlReq = URLRequest(url: url!)
        urlReq.allHTTPHeaderFields = [ "Authorization": "563492ad6f917000010000019fa343baaa754a2b904bc928dd3263b6" ]
        let asyncTask = session.dataTask(with: urlReq) {
            (data, response, error)->Void in
            if let jsonData = data {
                self.result = self.ImagesJsonCall(fromJSON: jsonData)
            } else if let requestErr = error {
                print(requestErr.localizedDescription)
            } else {
                print("Unexpected error with the request")
            }
            OperationQueue.main.addOperation {
                completion(self.result)
            }
        }
        asyncTask.resume()
    }
    
    struct imageData: Decodable {
        var id: String
        var photographer: String
        var src : Dictionary< String, String>
        var alt : String
    }
    
    func ImagesJsonCall(fromJSON data: Data)->ImagesResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let imgArr = jsonDictionary["photos"] as? [[String:Any]]
                else {
                    return .failure(JSONError.invalidJSONData)
            }
            var finalPhotos = [Image]()
            for imgJson in imgArr {
               // let size = imgJson["size"]["small"] as![[String:Any]]
                if let image = ImageFromJson(fromJSON: imgJson) {
                    finalPhotos.append(image)
                }
            }
            if finalPhotos.isEmpty && !imgArr.isEmpty {
                return .failure(JSONError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    func ImageFromJson(fromJSON json: [String:Any])->Image? {
        print(json)
        guard
            let id = json["id"] as! Int?,
            let author = json["photographer"] as! String?,
            let src = json["src"] as? [String: Any],
            let download_url = src["medium"] as! String?,
            let description = json["url"] as! String?
                    else {
            print("not working")
            return nil
        }
        print("downloaded url \(download_url)")
        print("data from json complete")
        return Image(id: id, download_url: download_url, author: author, description: description)
    }
    
    func fetchImage(for image: Image, completion: @escaping (ImageResult)->Void) {
        let ImgURL = image.download_url
        let ImgReq = URLRequest(url: URL(string: ImgURL)!)
        let asyncTask = session.dataTask(with: ImgReq) {
            (data, response, error)->Void in
            let result = self.displayImg(data: data, error: error)
            OperationQueue.main.addOperation {
                print("data fetched")
                completion(result)
            }
        }
        asyncTask.resume()
    }
    
    private func displayImg(data: Data?, error: Error?)->ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
        else {
            if (data == nil) {
                return .failure(error!)
            } else {
                return .failure(ImgErr.photoCreationError)
            }
        }
        return .success(image)
    }
}


