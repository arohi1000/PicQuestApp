//
//  ViewController.swift
//  PicQuestApp
//
//  Created by Priyadarsini, Anjali (Contractor) on 20/06/23.
//original

import UIKit

class ViewController: UIViewController {

    var enteredText: String=""
    var search : UISearchBar!
    var picList: [picInfo] = []
    var picImage = Utility()
    var isConnected = false
    
    
    //reference of viewModel , no reference of Model
    
    let vModel = PicQuestViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loadingProgress: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search Photos"
        navigationItem.searchController = search
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    func fetchImage(_ images: [picInfo]){
        self.picList = images
        
        //refresh the collectionView
        collectionView.reloadData()
    }
    
    
   }

    
    
    

extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("piclist count;\(picList.count)")
       return picList.count
    
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        
       
        
       let images = self.picList[indexPath.row]
        
        
       print(images)

        
        vModel.loadingPics(servers: images.server, ids: images.id, secret: images.secret, callback: { imageUrl in
            DispatchQueue.main.async {
                print("imageUrl:\(imageUrl)")
               let imgData = try! Data(contentsOf: imageUrl)

                 cell.img.image = UIImage(data: imgData)

                }
            })
        cell.contentView.layer.cornerRadius = 20
        
        return cell
        
    }
    
}

extension ViewController: UISearchBarDelegate{
    
    fileprivate func searchPhotos(_ keyword: String) {
        vModel.getPics(searchText: keyword, callback:  { data in
            
            print("data extracted")
            //new
            print(data)
            self.picList = data[0].photos.photo
            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }
            
            //          searchBar.resignFirstResponder()
            
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
     let keyword = searchBar.text ?? ""
        enteredText = keyword
        
        loadingProgress.stopAnimating()
       
        if !keyword.isEmpty{
            
            searchPhotos(keyword)
            
            }
        
        }
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text ?? ""
           enteredText = keyword
        if keyword.isEmpty{
            picList.removeAll()
            collectionView.reloadData()
        }
        
    }
    
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = picList[indexPath.item]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Cell") as! ImageVC
        
        vc.imageView = selectedImage
        
        show(vc, sender: self)
    }
}
