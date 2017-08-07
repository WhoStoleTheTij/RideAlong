//
//  ImageCollectionViewCell.swift
//  RideAlong
//
//  Created by Richard H on 03/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var connectionHandler = ConnectionHandler()
    
    
    func setCellImage(urlString: String){
        
        
        if urlString != "" && !urlString.isEmpty{
            
            self.connectionHandler.fetchImageData(urlString: urlString, completionHandler: { (data, error) in
                
                if error == nil{
                    DispatchQueue.main.async {
                        
                        self.imageView.image = UIImage(data: data! as Data)
                        self.activityView.isHidden = true
                        self.activityView.stopAnimating()
                        
                    }
                }else{
                    self.imageView.image = UIImage(named: "defaultImage")
                }
                
            })
            
            
        }
        
        
        
        
        
    }
    
    
}
