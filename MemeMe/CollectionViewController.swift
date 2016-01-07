//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Denis Ricard on 2015-12-27.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var aCollectionView: UICollectionView!
    
    var screenWidth:CGFloat=0
    var screenHeight:CGFloat=0

    func viewDidload() {
        super.viewDidLoad()

        print("THIS IS NEVER CALLED")
        
     }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        getScreenSize()
        setTheFlowLayout()

    }

    func getScreenSize(){
        screenWidth = self.view.frame.size.width
        screenHeight = self.view.frame.size.height
        print("SCREEN RESOLUTION: "+screenWidth.description+" x "+screenHeight.description)
    }
    
    func setTheFlowLayout() {
        
        let space: CGFloat = 3.0
        var dimensionX, dimensionY: CGFloat
        
        if screenHeight > screenWidth {
            dimensionX = (screenWidth - (1 * space)) / 2.0
            dimensionY = (screenHeight - (5 * space)) / 4.0
            
            print("PROTRAIT: screen width = \(screenWidth); screen height = \(screenHeight); dimensionX = \(dimensionX); dimensionY = \(dimensionY)")
            
        } else {
            dimensionY = (screenHeight - self.tabBarController!.tabBar.frame.size.height - (2 * space)) / 2.0
            dimensionX = (screenWidth - (5 * space)) / 4.0
            
            print("LANDSCAPE: screen width = \(screenWidth); screen height = \(screenHeight); dimensionX = \(dimensionX); dimensionY = \(dimensionY)")
            
        }

        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimensionX, dimensionY)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        getScreenSize()
        setTheFlowLayout()
        
        self.aCollectionView.reloadData()
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeCollectionViewCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = gMemes.memes[indexPath.item]
        
        cell.cvImage!.contentMode = .ScaleAspectFit
        cell.cvImage!.image = meme.memedImage
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.memedImageToDisplay = gMemes.memes[indexPath.row].memedImage
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gMemes.memes.count
    }
}