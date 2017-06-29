//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Rola Kitaphanich on 2016-06-30.
//  Copyright © 2016 Rola Kitaphanich. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var imagePicker: UIImageView!
    
    @IBOutlet weak var toolbar: UIToolbar!
   
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var topText = UITextField()

    var bottomText = UITextField()
    
    var memedImage = UIImage()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
 override func viewWillAppear(animated: Bool) {
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    func save (){
        
       let meme = Meme( top: topText.text!, bottom: bottomText.text!, imageView:imagePicker.image!, memedImage:memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func generateMemedImage() -> UIImage{
        
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        toolbar.hidden = false
        
        return memedImage
    }
    
    func shareButtonFunc(share:Bool){
        
        if(share){
            shareButton.enabled = true
        }
        
        else {
            shareButton.enabled = false
        }
    }
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
        
        UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if(bottomText.editing){
        
            view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
    
            view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.CGRectValue().height
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        formatText(topText)
        
        formatText(bottomText)

        shareButtonFunc(false)
       
    }
    
    func formatText (text: UITextField){
        
        text.delegate = self
        
        text.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
        text.adjustsFontSizeToFitWidth = true
        
        text.minimumFontSize = 12
        
        text.defaultTextAttributes = memeTextAttributes
        
        text.translatesAutoresizingMaskIntoConstraints = true
        
        if(text == topText){

            text.frame = CGRectMake(75,100,300,60)
            
            text.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY-110)
            
            text.text = "TOP"
        }
        
        else {
        
            text.frame = CGRectMake(75,340,300,60)
            
            text.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY+135)
            
            text.text = "BOTTOM"
        }
        
       text.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        
        text.textAlignment = NSTextAlignment.Center
        
        view.addSubview(text)
    
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(topText.text == "TOP" && textField.text == "TOP"){
            topText.text = ""
        }
        
        if(bottomText.text == "BOTTOM" && textField.text == "BOTTOM"){
            
            bottomText.text = ""
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        
        return true
    }
    
    
    @IBAction func pickImage(sender: AnyObject) {
        
       let imagePicker = UIImagePickerController ()
        
        imagePicker.delegate = self
        
        if(sender.tag == 1){
        
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        else if (sender.tag == 2) {
        
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        else {
            
            print("sender tag doesnt exist")
        }
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
   
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        if let image = info[ UIImagePickerControllerOriginalImage] as? UIImage {
            
            imagePicker.image = image
            
            shareButtonFunc(true)
        }

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelView(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        
        memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage as UIImage], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if(completed) {
            
                self.save()
            }
                
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
}

