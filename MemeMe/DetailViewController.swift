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
   
    // MARK: Properties
    
    var meme: Meme?
    
    // MARK: Outlets
    
    @IBOutlet var detailViewImage: UIImageView!
    
    // MARK: Lyfe Cycle
    
    override func viewDidLoad() {
        
        let b = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editImage")
        navigationItem.rightBarButtonItem = b
        
        if let meme = meme {
            detailViewImage.contentMode = .ScaleAspectFit
            detailViewImage.image = meme.memedImage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.hidden = false
    }
    
    // MARK: Utilities
    
    func editImage() {

        let editController = storyboard!.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        if let meme = meme {
            editController.passedTopText = meme.topText
            editController.passedBottomText = meme.bottomText
            editController.passedImage = meme.originalImage
        }
        
        navigationController!.pushViewController(editController, animated: true)

    }
}