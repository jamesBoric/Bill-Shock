//
//  AddDeviceViewController.swift
//  Bill Shock
//
//  Created by James Boric on 4/07/2015.
//  Copyright (c) 2015 Ode To Code. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController {
    
    @IBOutlet weak var photosScrollView: UIScrollView!
    
    @IBOutlet weak var brandsPickerView: UIPickerView!
    
    var selectedRoom: String! = ""
    
    var photos: [String] = []
    
    let fileManager = NSFileManager()
    
    var contextBrandsList: [[String]] = []
    
    var contextBrandsNames: [[String]] = []
    
    var photosClone: [String] = []
    
    var totalBrandsList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setBool(false, forKey: "showExtraDetail")
        
        println(selectedRoom)
        
        let path = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent("data")
        
        var error: NSError?
        
        let arbitraryFilesInDirectory: [String]! = fileManager.contentsOfDirectoryAtPath(path!, error: &error) as? [String]
        
        photos = arbitraryFilesInDirectory
        
        for fileName in arbitraryFilesInDirectory {
            let dataPath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent("data/\(fileName)")
            
            var error2: NSError?
            
            contextBrandsList += [fileManager.contentsOfDirectoryAtPath(dataPath!, error: &error) as! [String]]
        }
        
        for file in contextBrandsList {
            var additionList: [String] = []
            for i in file {
                additionList += [i.componentsSeparatedByString(".")[0]]
            }
            contextBrandsNames += [additionList]
            
        }
        
        
        photosClone = contextBrandsNames[0]
        
        for i in 0..<count(photos) {
            
            
            
            let photoView = UIImageView(frame: CGRectMake(view.frame.size.width * CGFloat(i), 0, view.frame.size.width, (view.frame.size.height - 16 - 44) / 2))
            photoView.clipsToBounds = true
            
            photoView.image = UIImage(named: photos[i])
            photoView.contentMode = .ScaleAspectFill
            photosScrollView.contentSize.width = view.frame.size.width * CGFloat(count(photos))
            
            let blackTextLabel = UILabel(frame: CGRectMake(2, 2, photoView.frame.size.width, photoView.frame.size.height))
            
            blackTextLabel.text = photos[i]
            blackTextLabel.textAlignment = .Center
            blackTextLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
            photoView.addSubview(blackTextLabel)
            
            let whiteTextLabel = UILabel(frame: CGRectMake(0, 0, photoView.frame.size.width, photoView.frame.size.height))
            whiteTextLabel.textColor = UIColor.whiteColor()
            whiteTextLabel.text = photos[i]
            whiteTextLabel.textAlignment = .Center
            whiteTextLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
            photoView.addSubview(whiteTextLabel)
            
            photosScrollView.addSubview(photoView)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return count(photosClone)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return photosClone[row]
    }
    
    var currentIndexOfScrollView = 0
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentIndexOfScrollView = Int(scrollView.contentOffset.x / view.frame.size.width)
        
        photosClone = contextBrandsNames[currentIndexOfScrollView]
        brandsPickerView.reloadAllComponents()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectModelSegue" {
            var svc = segue.destinationViewController as! SpecifyModelViewController
            
            svc.selectedBrand = contextBrandsList[currentIndexOfScrollView][brandsPickerView.selectedRowInComponent(0)]
            
            svc.selectedAppliance = photos[currentIndexOfScrollView]
            
            svc.saveDestination = selectedRoom
        }
    }
    
}
