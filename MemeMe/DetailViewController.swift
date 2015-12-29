//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Denis Ricard on 2015-12-27.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var detailViewImage: UIImageView!
    
    var memedImageToDisplay: UIImage?
    
    override func viewDidLoad() {
        
        if let image = memedImageToDisplay{
            detailViewImage.image = image
        }
    }
}