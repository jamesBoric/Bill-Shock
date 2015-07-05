//
//  AddRoomViewController.swift
//  Bill Shock
//
//  Created by James Boric on 4/07/2015.
//  Copyright (c) 2015 Ode To Code. All rights reserved.
//

import UIKit

class AddRoomViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    var capturePhoto: UIImage?
    
    @IBOutlet weak var capturedImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var roomNameTextField: UITextField!
    
    var fileManager = NSFileManager()
    
    var saveDir = ""
    
    @IBOutlet weak var addPhotoImageView: UIImageView!
    
    let cameraColours = [
        UIColor(red: 0 / 255, green: 180 / 255, blue: 158 / 255, alpha: 1),
        UIColor(red: 0 / 255, green: 204 / 255, blue: 124 / 255, alpha: 1),
        UIColor(red: 40 / 255, green: 154 / 255, blue: 214 / 255, alpha: 1),
        UIColor(red: 158 / 255, green: 91 / 255, blue: 176 / 255, alpha: 1),
        UIColor(red: 51 / 255, green: 73 / 255, blue: 92 / 255, alpha: 1),
        UIColor(red: 243 / 255, green: 194 / 255, blue: 68 / 255, alpha: 1),
        UIColor(red: 234 / 255, green: 124 / 255, blue: 56 / 255, alpha: 1),
        UIColor(red: 236 / 255, green: 74 / 255, blue: 66 / 255, alpha: 1),
        UIColor(red: 236 / 255, green: 240 / 255, blue: 241 / 255, alpha: 1),
        UIColor(red: 148 / 255, green: 165 / 255, blue: 166 / 255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        saveDir = dirPaths[0] as! String
        
        let numOfColours = cameraColours.count
        
        let randomIndex = random() % numOfColours
        
        addPhotoImageView.backgroundColor = cameraColours[randomIndex]
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func removeKeyboard(sender: UITextField) {
        sender.resignFirstResponder()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    
    @IBAction func donePressed(sender: UIBarButtonItem) {
        
        
        let roomName = roomNameTextField.text.componentsSeparatedByString(" ")
        let imageNameBase = join("-", roomName)
        let imageName = "\(imageNameBase).png"
        
        
        if roomNameTextField.text != "" && capturePhoto != nil {
            if !verifyFile("\(imageNameBase).csv") {
                saveImage(fixImageOrientation(capturePhoto!), path: saveDir.stringByAppendingPathComponent(imageName))
                createFile("\(imageNameBase).csv", contents: "\(roomNameTextField.text),\(imageName)")
            }
                
            else {
                let alert = UIAlertController(title: "Existing Room", message: "A room with this name has already been created. Please use a different name for this room.", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    println("Done")
                }
                
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            performSegueWithIdentifier("toHomeFromAddRoom", sender: self)
        }
            
        else if capturePhoto == nil {
            let noPhotoAlert = UIAlertController(title: "No Photo", message: "You have not added a photo for this room", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            
            noPhotoAlert.addAction(okAction)
            
            self.presentViewController(noPhotoAlert, animated: true, completion: nil)
        }
            
        else {
            let noNameAlert = UIAlertController(title: "No name", message: "You have not entered a name for this room", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            
            noNameAlert.addAction(okAction)
            
            self.presentViewController(noNameAlert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func createFile(name: String, contents: String) {
        
        let path = saveDir.stringByAppendingPathComponent(name)
        
        let contentsOfFile: String = contents
        var error: NSError?
        
        contentsOfFile.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
        
    }
    
    func verifyFile(fileName: String) -> Bool {
        var error: NSError?
        
        let filesInDirectory: [String]! = fileManager.contentsOfDirectoryAtPath(saveDir, error: &error) as? [String]
        
        if filesInDirectory.count > 0 {
            for i in 0..<filesInDirectory.count {
                if filesInDirectory[i] == fileName {
                    return true
                }
            }
        }
        
        return false
    }
    
    
    func viewContents(fileName: String) -> String {
        let path = saveDir.stringByAppendingPathComponent(fileName)
        let contentsOfFile = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        return contentsOfFile as! String
        
    }
    
    
    
    
    
    
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
