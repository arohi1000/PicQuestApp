//
//  Utility.swift
//  PicQuestApp
//
//  Created by Priyadarsini, Anjali (Contractor) on 20/06/23.
//

import Foundation

struct picInfo: Codable{
    
    var id: String
    var server: String
    var secret: String
    var title: String
    
}


struct baseInfo: Codable{
    
    var photo: [picInfo]
    
}

struct allInfo: Codable{
    var photos: baseInfo
    
}

struct Utility {
    
   
    
    static let shared = Utility()
    
    func getPhoto(searchText: String, handler: @escaping ([allInfo])-> Void){
        
        let picURL = ("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=67bbb377ac8922e0bc3e44f61a8a20af&text=\(searchText)&format=json&nojsoncallback=1")
        
        
        if let url = URL(string: picURL){
            
            
            let session = URLSession.shared
            let task = session.dataTask(with: url) { picData, picResp, error in
                
                if error == nil{
                    print("Request suucess: \(picURL)")
                    
                    
                    
                    let status = (picResp as! HTTPURLResponse).statusCode
                    switch status{
                    case 20...299:
                        
                        print("Success")
                        
                        let picList = parsePicData(jsonResponse: picData)
                        
                        handler(picList)
                        
                    case 300...399:
                        print("Redirection")
                    case 400...499:
                        
                        print("Client error")
                    case 500...599:
                        
                        print("Server error")
                    default:
                        print("Unknown error")
                    }
                }
                else {
                    print("Request could not be completed")
                }
                
            }
            //resume tasks
            task.resume()
            
        }
        else{
            print("Invalid URL")
        }
    }
    
    func parsePicData(jsonResponse: Data?) -> [allInfo]{
        guard let jResponse = jsonResponse else
        {
            return []
        }
        do{
            let picdata = try JSONDecoder().decode(allInfo.self, from: jResponse)
            print("count will be \(picdata.photos.photo.count)")
            
            return [picdata]
        }
        catch{
            print("Parsing of data has failed due to \(error.localizedDescription)")
        }
        return []
        
    }
    
    func picLoading(server: String, id: String,secret: String, callback : @escaping (URL)->Void){
        
        let imgURL = "https://live.staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
        
        
        let documntURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let imagePath = documntURL.appendingPathComponent("\(id).jpg")
        
        if FileManager.default.fileExists(atPath: imagePath.relativePath){
            callback(imagePath)
            return
        }
        
        let session = URLSession.shared
        
        if let imageUrl = URL(string: imgURL){
            
            let task = session.downloadTask(with: imageUrl) { tempURL, resp, err in
                // tempURL - location of temp file where downloaded data is saved
                if err == nil{
                    let statusC = (resp as! HTTPURLResponse).statusCode
                    
                    
                    if statusC == 200{
                        
                        try! FileManager.default.moveItem(at: tempURL!, to: imagePath)
                        callback(imagePath)
                    }
                    else{
                        
                        print("Something went wrong: \(statusC) ")
                        
                    }
                    
                }
                
                else{
                    
                    print("network issue \(imgURL)")
                    
                }
                
            }
//resume tasks
            task.resume()
        }
        else{
            print("invalid url")
        }
    }
}
