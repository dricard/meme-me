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
    
    func viewDidload() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (3 * space)) / 2.0
        
        print("screen width = \(self.view.frame.size.width); dimension = \(dimension)")
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        let space: CGFloat = 3.0
        let dimensionX = (self.view.frame.size.width - (3 * space)) / 2.0
        let dimensionY = (self.view.frame.size.height - (5 * space)) / 4.0

        print("screen width = \(self.view.frame.size.width); dimensionX = \(dimensionX); dimensionY = \(dimensionY)")
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimensionX, dimensionY)
        self.aCollectionView.reloadData()
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SentMemeCollectionViewCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = gMemes.memes[indexPath.item]
        
        cell.cvImage?.image = meme.memedImage
        
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