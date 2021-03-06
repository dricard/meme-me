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
    
    // MARK: Properties
    
    var screenWidth:CGFloat=0
    var screenHeight:CGFloat=0
    
    // MARK: Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var aCollectionView: UICollectionView!
    
    // MARK: Lyfe Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.hidden = false
        getScreenSize()
        setTheFlowLayout()
        
        aCollectionView.reloadData()
        
    }
    
    
    // MARK: Utilities
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        getScreenSize()
        setTheFlowLayout()
    }

    func getScreenSize(){
        screenWidth = view.frame.size.width
        screenHeight = view.frame.size.height
    }
    
    func setTheFlowLayout() {
        
        let space: CGFloat = 3.0
        var dimensionX, dimensionY: CGFloat
        
        if screenHeight > screenWidth {
            dimensionX = (screenWidth - (1 * space)) / 2.0
            dimensionY = (screenHeight - (5 * space)) / 4.0
        } else {
            dimensionY = (screenHeight - tabBarController!.tabBar.frame.size.height - (2 * space)) / 2.0
            dimensionX = (screenWidth - (5 * space)) / 4.0          
        }

        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimensionX, dimensionY)

    }
    
    // MARK: Collection View Delegates
   
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeCollectionViewCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = gMemes.memes[indexPath.item]
        
        cell.cvImage!.contentMode = .ScaleAspectFit
        cell.cvImage!.image = meme.memedImage
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = gMemes.memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gMemes.memes.count
    }
}