//
//  TableViewController.swift
//  MemeMe
//
//  Created by Denis Ricard on 2015-12-27.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeTableViewCell", forIndexPath: indexPath)
        let meme = gMemes!.memes[indexPath.row]
        
        cell.textLabel!.text = meme.topText + " " + meme.bottomText
        cell.imageView!.image = meme.memedImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.memedImageToDisplay? = gMemes!.memes[indexPath.row].memedImage
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfMemes = gMemes!.memes.count
        print("Number of memes is \(numberOfMemes)")
        return numberOfMemes
    }

}