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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeTableViewCell", forIndexPath: indexPath)
        let meme = gMemes.memes[indexPath.row]
        
        cell.textLabel!.text = meme.topText + " " + meme.bottomText
        cell.imageView!.image = meme.memedImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = gMemes.memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfMemes = gMemes.memes.count
            return numberOfMemes
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let _ = gMemes.memes.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }

}