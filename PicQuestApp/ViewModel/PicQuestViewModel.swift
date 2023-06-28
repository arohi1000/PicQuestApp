//
//  PicQuestViewModel.swift
//  PicQuestApp
//
//  Created by Priyadarsini, Anjali (Contractor) on 21/06/23.
//
// this has refernce to model, but no reference of view
import Foundation


struct PicQuestViewModel{
    let picModel = Utility.shared
    
    func getPics(searchText: String, callback: @escaping (([allInfo]) -> Void)){
        
        picModel.getPhoto(searchText: searchText, handler: callback)
        
    }
    func loadingPics(servers: String, ids: String, secret: String, callback: @escaping (URL)-> Void){
        picModel.picLoading(server: servers, id: ids, secret: secret, callback: callback)
    }
    
}


//Rule of MVVM View should never talk to the model directly
