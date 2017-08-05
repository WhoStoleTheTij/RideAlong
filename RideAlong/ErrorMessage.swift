//
//  ErrorMessage.swift
//  RideAlong
//
//  Created by Richard H on 05/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import Foundation
import UIKit


class ErrorMessage{
    
    static func displayErrorMessage(message: String, view: UIViewController){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        view.present(alert, animated: true, completion: nil)
    }
    
    
    
}
