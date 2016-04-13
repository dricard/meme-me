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
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lyfe Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.hidden = false
        tableView.reloadData()
    }
    
    // MARK: TableView delegates
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeTableViewCell", forIndexPath: indexPath)
        let meme = gMemes.memes[indexPath.row]
        
        cell.textLabel!.text = meme.topText + " " + meme.bottomText
        cell.imageView!.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailController.meme = gMemes.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfMemes = gMemes.memes.count
        return numberOfMemes
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let _ = gMemes.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }

}