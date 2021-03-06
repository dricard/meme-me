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
  
    // MARK: Properties
    
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    var permitAutoRotate = true
    var passedImage : UIImage?
    var passedTopText, passedBottomText : String?
    
    
    let memeTextAttributes : [ String : AnyObject ] = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    // MARK: Outlets
    
    @IBOutlet var imageViewer: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var topToolBar: UIToolbar!
    @IBOutlet var bottomToolBar: UIToolbar!

    // MARK: Lyce Cycle
    
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
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.hidden = true
        subscribeToKeyboardShowNotifications()
        // Here is some code for when this is called from the detail view. Instead of presenting
        // an empty view and letting the user choose Album or Take a picture, here we must
        // set-up the interface with an already made meme. So the first time true ViewWillAppear
        // we set those up (picture and text) but then we return the variables to nil so that
        // the modifications made by the user in the interface is not overwritten the nest time
        // we come to view will appear (after sharing for instance)
        if let topText = passedTopText {
            topTextField.text = topText
            passedTopText = nil
        }
        if let bottomText = passedBottomText {
            bottomTextField.text = bottomText
            passedBottomText = nil
        }
        if let image = passedImage {
            setUIWithImage(image)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeToKeyboardShowNotifications()
        navigationController?.navigationBar.hidden = false
    }

    // MARK: User actions
    
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
    
    @IBAction func useDidCancel(sender: AnyObject) {
        resetInterface()
        if let navigationController = navigationController {
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
                // self is required here because it's a closure
                self.save()
            }
        }
        presentViewController(activity, animated: true, completion: nil)
    }
    
    // MARK: Utilities
    
    func setUIWithImage(image: UIImage) {
        imageViewer.contentMode = .ScaleAspectFit
        imageViewer.image = image
        topTextField.hidden = false
        bottomTextField.hidden = false
        instructionsLabel.hidden = true
        shareButton.enabled = true
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: nil)
        setUIWithImage(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, memedImage: generateMemedImage(), originalImage: imageViewer.image!)
        gMemes.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // First we hide the toolbars
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        
        // We get some measures for the crop we'll need to do after the screen grab
        let crop = topToolBar.frame.height
        let statusCrop: CGFloat = ( orientationIsLandscape() ? 0 : 20)
        let trim : CGFloat = 2
        
        let contextSize = view.frame.size
        
        // This is the screen grab
        UIGraphicsBeginImageContext(contextSize)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)

        let uncroppedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // we're done with the screen grab, replace the tool bars
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        
        // Now crop the image to remove the parts that the tool bars were in
        let cropRect = CGRectMake(trim , crop + statusCrop, view.frame.size.width - 2 * trim, view.frame.size.height - 2 * crop - statusCrop)
        let croppedImage = CGImageCreateWithImageInRect(uncroppedImage.CGImage, cropRect)
        let memedImage = UIImage(CGImage: croppedImage!)
        
        return memedImage
    }

    // MARK: Interface
    
    func orientationIsLandscape() -> Bool {
        return view.frame.height < view.frame.width
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
    
    // MARK: Text Field Delegates
    
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
    
    // MARK: Keyboard utilities
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardShowNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardHideNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
}