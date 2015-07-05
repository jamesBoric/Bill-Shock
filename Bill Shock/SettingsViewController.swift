//
//  SettingsViewController.swift
//  Bill Shock
//
//  Created by James Boric on 3/07/2015.
//  Copyright (c) 2015 Ode To Code. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    @IBOutlet weak var electricityPriceTextField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var periodTextField: UITextField!
    
    @IBOutlet weak var addPhotoImageView: UIImageView!
    
    var saveDir = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        saveDir = dirPaths[0] as! String
        
        if loadImageFromPath(saveDir.stringByAppendingPathComponent("housePhoto.png")) != nil {
            addPhotoImageView.image = loadImageFromPath(saveDir.stringByAppendingPathComponent("housePhoto.png"))
        }
        
        var userInfoDefaults = NSUserDefaults.standardUserDefaults()
        
        let electricity = userInfoDefaults.doubleForKey("userElectricityPrice")
        
        electricityPriceTextField.text = "\(electricity)"
        
        addressField.text = userInfoDefaults.stringForKey("userAddress")
        
        let period = userInfoDefaults.doubleForKey("period")
        
        periodTextField.text = "\(period)"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAndLeave(sender: UIBarButtonItem) {
        var userInfo = NSUserDefaults.standardUserDefaults()
        userInfo.setObject(addressField.text, forKey: "userAddress")
        userInfo.setDouble((electricityPriceTextField.text as NSString).doubleValue, forKey: "userElectricityPrice")
        userInfo.setDouble((periodTextField.text as NSString).doubleValue, forKey: "period")
        
        if addPhotoImageView.image != nil {
            saveImage(addPhotoImageView.image!, path: saveDir.stringByAppendingPathComponent("housePhoto.png"))
        }
        
        performSegueWithIdentifier("settingsToHomeSegue", sender: self)
    }
    @IBAction func moveViewDown(sender: AnyObject) {
        UIView.animateWithDuration(0.3) {
            self.view.frame.origin.y = 0
        }
        
    }
    @IBAction func moveViewUpForContent(sender: AnyObject) {
        UIView.animateWithDuration(0.3) {
            self.view.frame.origin.y = -150
        }
    }
    
    @IBAction func moveViewUp2x(sender: UITextField) {
        UIView.animateWithDuration(0.3) {
            self.view.frame.origin.y = -200
        }
    }
    
    
    @IBAction func resignKeyboard(sender: UITextField) {
        
        sender.resignFirstResponder()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    
    
    
    
    var capturePhoto: UIImage?
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    @IBAction func btnImagePickerClicked(sender: AnyObject) {
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
            
        }
        var GalleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallery()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            
        }
        
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(GalleryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        return image
        
    }
    
    
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else {
            openGallery()
        }
    }
    
    func openGallery() {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        
    }
    @IBOutlet weak var capturedImageViewHeight: NSLayoutConstraint!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        addPhotoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        capturePhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let scaleRatio = view.frame.size.width / capturedImage!.size.width
        
        capturedImageViewHeight.constant = capturedImage!.size.height * scaleRatio
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        addPhotoImageView.image = capturedImage
        
        //saveImage(fixImageOrientation(addPhotoImageView.image!), path: saveDir.stringByAppendingPathComponent("profilePic"))
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func fixImageOrientation(img:UIImage) -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (img.imageOrientation == UIImageOrientation.Up) {
            return img;
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransformIdentity
        
        if (img.imageOrientation == UIImageOrientation.Down
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if (img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, 0, img.size.height);
                transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.UpMirrored
            || img.imageOrientation == UIImageOrientation.DownMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.width, 0)
                transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.RightMirrored) {
                
                transform = CGAffineTransformTranslate(transform, img.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        var ctx:CGContextRef = CGBitmapContextCreate(nil,
            Int(img.size.width),
            Int(img.size.height),
            CGImageGetBitsPerComponent(img.CGImage), 0,
            CGImageGetColorSpace(img.CGImage),
            CGImageGetBitmapInfo(img.CGImage));
        
        CGContextConcatCTM(ctx, transform)
        
        
        if (img.imageOrientation == UIImageOrientation.Left
            || img.imageOrientation == UIImageOrientation.LeftMirrored
            || img.imageOrientation == UIImageOrientation.Right
            || img.imageOrientation == UIImageOrientation.RightMirrored
            ) {
                
                CGContextDrawImage(ctx, CGRectMake(0,0,img.size.height,img.size.width), img.CGImage)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,img.size.width,img.size.height), img.CGImage)
        }
        
        
        // And now we just create a new UIImage from the drawing context
        var cgimg:CGImageRef = CGBitmapContextCreateImage(ctx)
        var imgEnd:UIImage = UIImage(CGImage: cgimg)!
        
        return imgEnd
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool {
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 0)   // if you want to save as JPEG
        let result = pngImageData.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
