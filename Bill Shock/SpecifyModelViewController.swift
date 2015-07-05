//
//  specifyModelViewController.swift
//  Bill Shock
//
//  Created by James Boric on 5/07/2015.
//  Copyright (c) 2015 Ode To Code. All rights reserved.
//

import UIKit

class SpecifyModelViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    @IBOutlet weak var modelsScrollView: UIScrollView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var bottomScrollViewToBottom: NSLayoutConstraint!
    @IBOutlet weak var titleBar: UINavigationItem!
    
    @IBOutlet weak var topScrollViewToTop: NSLayoutConstraint!
    
    @IBOutlet weak var waitLabel: UILabel!
    
    @IBOutlet weak var timeUsePickerView: UIPickerView!
    
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
    
    var saveDestination: String! = ""
    
    var fileManager = NSFileManager()
    
    var saveDir = ""
    
    var selectedBrand: String = ""
    
    var selectedAppliance: String = ""
    
    let timeUsageOptions = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12, 12.5, 13, 13.5, 14, 14.5, 15, 15.5, 16, 16.5, 17, 17.5, 18, 18.5, 19, 19.5, 20, 20.5, 21, 21.5, 22, 22.5, 23, 23.5, 24]
    
    var models: [[String]] = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        println(userDefaults.boolForKey("showExtraDetail"))
        
        if userDefaults.boolForKey("showExtraDetail") {
            bottomScrollViewToBottom.constant = view.frame.size.height - 64
        }
        
        let numOfColours = cameraColours.count
        
        let randomIndex = random() % numOfColours
        
        addPhotoImageView.backgroundColor = cameraColours[randomIndex]
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        saveDir = dirPaths[0] as! String
        
        var counter = 0
        let path = NSBundle.mainBundle().pathForResource("data/\(selectedAppliance)/\(selectedBrand)", ofType: "")
        
        models = undoCSV(path!)
        for i in models {
            let modelView = UIView(frame: CGRectMake(0, CGFloat(counter) * 120, view.frame.size.width, 120))
            modelView.tag = counter
            
            let showUsagePrompt = UITapGestureRecognizer(target: self, action: "promptForTime:")
            
            modelView.addGestureRecognizer(showUsagePrompt)
            
            let modelNumber = UILabel(frame: CGRectMake(20, 10, view.frame.size.width - 40, 30))
            modelNumber.text = i[0]
            modelNumber.font = UIFont(name: "HelveticaNeue", size: 30)
            
            modelView.addSubview(modelNumber)
            
            let descriptionLabel = UILabel(frame: CGRectMake(20, 10 + modelNumber.frame.size.height + 10, view.frame.size.height - 40, 15))
            
            descriptionLabel.textColor = UIColor.grayColor()
            descriptionLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 12)
            descriptionLabel.text = "\(i[2]) - \(i[3]) - \(i[4])"
            
            modelView.addSubview(descriptionLabel)
            
            
            //println(models[0][6])
            let stars: Double = (i[6] as NSString).doubleValue
            
            for i in 0..<Int(floor(stars)) {
                let starView = UIView(frame: CGRectMake(CGFloat(i) * 30 + 20,
                    10 + modelNumber.frame.size.height + 10 + descriptionLabel.frame.size.height + 10,
                    20,
                    20
                    )
                )
                starView.backgroundColor = UIColor(red: 147 / 256, green: 116 / 256, blue: 233 / 256, alpha: 1)
                starView.layer.cornerRadius = starView.frame.size.height / 2
                modelView.addSubview(starView)
            }
            
            if stars % 1 != 0 {
                let lastX1 = (CGFloat(floor(stars)) * 30 + 20)
                
                let lastX2 = (20 * (1 - (stars % 1))) / 2
                
                let lastY1 = 10 + modelNumber.frame.size.height + 10 + descriptionLabel.frame.size.height + 10
                
                let endView = UIView(frame: CGRectMake(
                    
                    lastX1 + CGFloat(lastX2),
                    
                    lastY1 + CGFloat(lastX2),
                    
                    20 * CGFloat(stars % 1),
                    
                    20 * CGFloat(stars % 1)
                    
                    )
                )
                endView.layer.cornerRadius = endView.frame.size.height / 2
                endView.backgroundColor = UIColor(red: 147 / 256, green: 116 / 256, blue: 233 / 256, alpha: 1)
                modelView.addSubview(endView)
            }
            
            let starsLabel = UILabel(frame: CGRectMake(20, 10 + modelNumber.frame.size.height + 10 + descriptionLabel.frame.size.height + 10 + 20 + 5, view.frame.size.width - 40, 10))
            
            if stars > 0 {
                starsLabel.text = "\(stars) stars"
            }
            else {
                starsLabel.text = "Undetermined"
            }
            
            starsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 10)
            starsLabel.textColor = UIColor.grayColor()
            modelView.addSubview(starsLabel)
            modelsScrollView.addSubview(modelView)
            
            
            counter++
        }
        
        
        modelsScrollView.contentSize.height = 120 * CGFloat(counter)
        
        
        
        
        activityIndicator.stopAnimating()
        waitLabel.hidden = true
        
        
    }
    
    var currentSelection = ""
    
    func promptForTime(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.3) {
            self.modelsScrollView.frame.origin.y = 64 - self.view.frame.size.height
        }
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(true, forKey: "showExtraDetail")
        
        currentSelection = ",".join(models[sender.view!.tag])
        
    }
    
    
    
    @IBAction func addDeviceToRoom(sender: UIBarButtonItem) {
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(false, forKey: "showExtraDetail")
        
        println(saveDestination)
        
        var modelNumber = currentSelection.componentsSeparatedByString(",")[0]
        
        if contains(modelNumber, "/") {
            modelNumber = "".join(modelNumber.componentsSeparatedByString("/"))
        }
        
        let brand = currentSelection.componentsSeparatedByString(",")[1]
        
        println(saveDir.stringByAppendingPathComponent("\(saveDestination)-\(modelNumber)-\(selectedAppliance).png"))
        println(                                       "\(saveDestination)-\(modelNumber)-\(selectedAppliance).png")
        
        editContent(saveDestination, replacementContents: "\(viewContents(saveDestination))\n\(currentSelection),\(selectedAppliance),\(timeUsageOptions[timeUsePickerView.selectedRowInComponent(0)]),\(saveDestination)-\(modelNumber)-\(selectedAppliance).png")
        
        saveImage(fixImageOrientation(addPhotoImageView.image!)
            
            , path: saveDir.stringByAppendingPathComponent("\(saveDestination)-\(modelNumber)-\(selectedAppliance).png"))
        
        var alert = UIAlertController(title: "Saved", message: "You have saved your \(brand) \(selectedAppliance). Would you like to add another device?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let redo = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.performSegueWithIdentifier("modelToDeviceSegue", sender: self)
        }
        
        let finish = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { UIAlertAction in
            self.performSegueWithIdentifier("toHomeScreen", sender: self)
        }
        
        alert.addAction(finish)
        
        
        alert.addAction(redo)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        let brandForTitle = selectedBrand.componentsSeparatedByString(".")[0]
        titleBar.title = "\(brandForTitle) \(selectedAppliance)"
        
        
        //models = undoCSV(path!)
        
        //println(count(models))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewContents(fileName: String) -> String {
        let path = saveDir.stringByAppendingPathComponent(fileName)
        let contentsOfFile = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        return contentsOfFile as! String
        
    }
    
    func undoCSV(filePath: String) -> [[String]] {
        
        let contentsOfFile = NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil) as! String
        
        var array1: [String] = contentsOfFile.componentsSeparatedByString("\n")
        
        var returnArray: [[String]] = []
        
        var isInQuotes = false
        
        var quoteResetNum = 0
        for i in array1[1..<count(array1)] {
            if i != "" {
                var toAppendToArray: [String] = []
                var temp = ""
                for n in 0..<count(i) {
                    if Array(i)[n] == "," && isInQuotes == false {
                        toAppendToArray += [temp]
                        temp = ""
                    }
                        
                    else if Array(i)[n] == "\"" {
                        if quoteResetNum % 2 == 0 {
                            isInQuotes = true
                        }
                            
                        else if quoteResetNum % 2 != 0 {
                            toAppendToArray += [temp]
                            temp = ""
                            isInQuotes = false
                        }
                        quoteResetNum++
                    }
                        
                    else if n == count(i) - 1 {
                        temp += String(Array(i)[n])
                        toAppendToArray += [temp]
                    }
                        
                    else {
                        temp += String(Array(i)[n])
                    }
                    
                }
                
                var indexesToRemove: [Int] = []
                for l in 0..<count(toAppendToArray) {
                    if contains(toAppendToArray[l], ",") {
                        if l != count(toAppendToArray) - 1 {
                            indexesToRemove += [l + 1]
                        }
                    }
                }
                
                for var m = count(indexesToRemove) - 1; m >= 0; m-- {
                    toAppendToArray.removeAtIndex(indexesToRemove[m])
                }
                returnArray.append(toAppendToArray)
            }
        }
        
        return returnArray
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeUsageOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(timeUsageOptions[row])"
    }
    
    
    func editContent(file: String, replacementContents: String) {
        let path = saveDir.stringByAppendingPathComponent(file)
        let contentsOfFile: String = replacementContents
        var error: NSError?
        
        contentsOfFile.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "modelToDeviceSegue" {
            var svc = segue.destinationViewController as! AddDeviceViewController
            
            svc.selectedRoom = saveDestination
        }
    }
    
    
    
    //Camera
    var capturePhoto: UIImage?
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    @IBAction func btnImagePickerClicked(sender: AnyObject) {
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        println(userDefaults.boolForKey("showExtraDetail"))
        
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
}
