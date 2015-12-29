//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by Denis Ricard on 2015-12-27.
//  Copyright © 2015 Hexaedre. All rights reserved.
//

import Foundation
import UIKit

class EditMemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
  
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    var permitAutoRotate = true
    
   
    
    
    @IBOutlet var imageViewer: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var topToolBar: UIToolbar!
    @IBOutlet var bottomToolBar: UIToolbar!

    
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickController, animated: true, completion: nil)
    }

    @IBAction func takePicture(sender: AnyObject) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageViewer.contentMode = .ScaleAspectFit
        imageViewer.image = image
        dismissViewControllerAnimated(true, completion: nil)
        topTextField.hidden = false
        bottomTextField.hidden = false
        instructionsLabel.hidden = true
        shareButton.enabled = true
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func useDidCancel(sender: AnyObject) {
        resetInterface()
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
    }

    
    @IBAction func shareMeme(sender: AnyObject) {
        let textToShare = "Check this meme!"
        let memedImage = generateMemedImage()
        let objectsToShare = [ textToShare, memedImage ]
        let activity = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activity.completionWithItemsHandler = {
            (activity, success, items, error) in
            if let _ = error {
                print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            }
            if success {
                self.save()
            }
        }
        presentViewController(activity, animated: true, completion: nil)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, memedImage: generateMemedImage(), originalImage: imageViewer.image!)
        gMemes!.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // First we hide the toolbars
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        
        return memedImage
    }
    
    let memeTextAttributes : [ String : AnyObject ] = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        resetInterface()
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if !cameraButton.enabled {
            instructionsLabel.text = "Choose an image from the Album \n(no camera on this device)"
        }
        
        subscribeToKeyboardShowNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeToKeyboardShowNotifications()
    }
    
    override func shouldAutorotate() -> Bool {
        // Lock autorotate as appropriate (i.e., while editing text field)
        return permitAutoRotate
    }
    
    func resetInterface() {
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        topTextField.hidden = true
        bottomTextField.hidden = true
        imageViewer.image = nil
        instructionsLabel.hidden = false
        shareButton.enabled = false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // if default text is still in the text field we clear on begin editing, otherwise we leave user text
        if let text = textField.text {
            if text == defaultTopText || text == defaultBottomText {
                textField.text = ""
            }
        }
        // Since we move the view while the keyboard is shown and since the keyboard has different height
        // in portrait and landscape views, we prevent autoRotation while editing
        // we re-allow it in textfieldShouldReturn
        permitAutoRotate = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // Since we move the view while the keyboard is shown and since the keyboard has different height
        // in portrait and landscape views, we prevented autoRotation while editing in textfieldShouldReturn
        permitAutoRotate = true
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            let kbHeight = getKeyboardHeight(notification)
            view.frame.origin.y = -kbHeight
        }
        subscribeToKeyboardHideNotification()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
        unsubscribeToKeyboardHideNotification()
    }
    
    func subscribeToKeyboardShowNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardHideNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}