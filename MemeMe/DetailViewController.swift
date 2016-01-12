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
    
    var meme: Meme?
    
    override func viewDidLoad() {
        
        let b = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editImage")
        self.navigationItem.rightBarButtonItem = b
        
        if let meme = meme {
            detailViewImage.contentMode = .ScaleAspectFit
            detailViewImage.image = meme.memedImage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
    }
    
    func editImage() {

        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("EditMemeViewController") as! EditMemeViewController
        if let meme = meme {
            editController.passedTopText = meme.topText
            editController.passedBottomText = meme.bottomText
            editController.passedImage = meme.originalImage
        }
        
        self.navigationController!.pushViewController(editController, animated: true)

    }
}