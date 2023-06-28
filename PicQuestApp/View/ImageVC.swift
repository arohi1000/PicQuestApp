//
//  imageVC.swift
//  PicQuestApp
//
//  Created by Priyadarsini, Anjali (Contractor) on 21/06/23.
//

import UIKit

var picImage = Utility()
var image: [picInfo] = []

class ImageVC: UIViewController {
    
    @IBOutlet weak var enteredT: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
   
    
    var imageView: picInfo?
    let vModel = PicQuestViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageView = imageView{
            titleLabel.text = imageView.title
            
            vModel.loadingPics(servers: imageView.server, ids: imageView.id, secret: imageView.secret, callback: { imageUrl in
                let imgData = try! Data(contentsOf: imageUrl)
                
                self.photoView.image = UIImage(data: imgData)
            })
        }
        photoView.layer.cornerRadius = 30
        
        
    }
    
  
    @IBAction func shareClick(_ sender: Any) {
        print("Clicked -------")
        guard let image = photoView.image else{
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
}
