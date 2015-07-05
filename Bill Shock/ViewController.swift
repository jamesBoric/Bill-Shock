//
//  ViewController.swift
//  Bill Shock
//
//  Created by James Boric on 3/07/2015.
//  Copyright (c) 2015 Ode To Code. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var controllerScrollView: UIScrollView!
    
    
    var fileManager = NSFileManager()
    
    var saveDir = ""
    
    @IBOutlet weak var homeTitleBar: UINavigationItem!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    var elementsNum = 0
    
    let roomInfoScrollView = UIScrollView()
    
    var roomViewHasExpanded = false
    
    var currentOpenView = 0
    
    var csvFilesArray: [String] = []
    var userInfoDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        saveDir = dirPaths[0] as! String
        
        var error2: NSError?
        
        //deleteFile(saveDir.stringByAppendingPathComponent("b.png"))
        
        let houseSummaryView = UIView(frame: CGRectMake(10, 10, view.frame.size.width - 20, view.frame.size.height - 94))
        
        houseSummaryView.backgroundColor = UIColor.whiteColor()
        
        houseSummaryView.clipsToBounds = true
        
        houseSummaryView.layer.cornerRadius = (view.frame.size.width * 2 / 3 - 20) / 10
        
        
        
        controllerScrollView.addSubview(houseSummaryView)
        
        let houseImageView = UIImageView(frame: CGRectMake(0, 0, houseSummaryView.frame.size.width, houseSummaryView.frame.size.width / 2))
        
        
        houseImageView.image = UIImage(named: "houseIcon")
        
        if loadImageFromPath(saveDir.stringByAppendingPathComponent("housePhoto.png")) != nil {
            houseImageView.image = loadImageFromPath(saveDir.stringByAppendingPathComponent("housePhoto.png"))
        }
            
        else {
            houseImageView.image = UIImage(named: "houseIcon")
        }
        
        houseImageView.backgroundColor = UIColor.redColor()
        
        houseSummaryView.addSubview(houseImageView)
        
        let addressLabel = UILabel(frame: CGRectMake(10, houseImageView.frame.size.height + 10, houseSummaryView.frame.size.width - 20, 40))
        
        
        addressLabel.text = userInfoDefaults.stringForKey("userAddress")
        
        addressLabel.adjustsFontSizeToFitWidth = true
        
        addressLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 74)
        
        addressLabel.numberOfLines = 2
        
        houseSummaryView.addSubview(addressLabel)
        
        
        pageControl.numberOfPages = 2
        
        pageControl.currentPage = 0
        
        updateInterface()
    }
    
    
    func expandRoomView(sender: UITapGestureRecognizer) {
        
        currentOpenView = sender.view!.tag
        
        let totalTime: CFTimeInterval = 0.2
        if !roomViewHasExpanded {
            
            homeTitleBar.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "activateDeleteRoom:")
            
            /*trashButton?.alpha = 0
            UIView.animateWithDuration(totalTime) {
            trashButton?.alpha = 1
            }*/
            
            roomInfoScrollView.scrollEnabled = false
            roomInfoScrollView.contentSize.height = CGFloat(elementsNum - 1) * (view.frame.size.width * 2 / 3) + view.frame.size.height
            for i in 1...elementsNum {
                roomViewHasExpanded = true
                if i > sender.view?.tag {
                    UIView.animateWithDuration(totalTime, delay: 0.0, options: .CurveEaseInOut, animations: ({
                        view.viewWithTag(i)?.frame.origin.y += (view.frame.size.height - 16 - 44 - 10) - (view.frame.size.width * 2 / 3) - 5
                    }), completion: nil)
                    
                    
                    
                }
                else {
                    UIView.animateWithDuration(totalTime, delay: 0.0, options: .CurveEaseInOut, animations: ({
                        sender.view?.frame.size.height = view.frame.size.height - 16 - 44 - 10 - 25
                    }), completion: nil)
                    
                }
            }
            UIView.animateWithDuration(totalTime, delay: 0.0, options: .CurveEaseInOut, animations: ({
                let contentOffset = CGFloat(sender.view!.tag - 1) * (self.view.frame.size.width * 2 / 3)
                self.roomInfoScrollView.contentOffset.y = contentOffset
            }), completion: nil)
        }
            
        else {
            
            /*let trashButton = homeTitleBar.leftBarButtonItem?.customView
            
            UIView.animateWithDuration(totalTime, animations: { () in
            trashButton?.alpha = 0
            
            
            
            }, completion: {(Bool)  in
            //trashButton?.hidden = true
            })*/
            
            homeTitleBar.leftBarButtonItem = UIBarButtonItem(image:UIImage(named: "settingsIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "moveToSettingsPane")
            
            roomInfoScrollView.scrollEnabled = true
            for i in 1...elementsNum {
                roomViewHasExpanded = false
                if i > sender.view?.tag {
                    let differenceForCompression = (view.frame.size.height - 16 - 44 - 10) - (view.frame.size.width * 2 / 3) - 5
                    UIView.animateWithDuration(totalTime, delay: 0.0, options: .CurveEaseInOut, animations: ({
                        view.viewWithTag(i)?.frame.origin.y -= differenceForCompression
                    }), completion: nil)
                    
                    
                    
                }
                    
                else {
                    UIView.animateWithDuration(totalTime, delay: 0.0, options: .CurveEaseInOut, animations: ({
                        sender.view?.frame.size.height = view.frame.size.width * 2 / 3 - 20
                    }), completion: nil)
                    
                }
            }
            UIView.animateWithDuration(totalTime, delay: 0.0, options: .CurveEaseInOut, animations: ({
                let contentOffset = CGFloat(sender.view!.tag - 1) * (self.view.frame.size.width * 2 / 3)
                self.roomInfoScrollView.contentOffset.y = contentOffset
                
                self.roomInfoScrollView.contentSize.height = CGFloat(self.elementsNum) * (self.view.frame.size.width * 2 / 3) - 10
            }), completion: nil)
            
            
        }
        //viewToExpand.view?.frame = CGRectMake(10, 10, view.frame.size.width - 20, view.frame.size.height - 20 - 16 - 44)
    }
    
    func moveToSettingsPane() {
        performSegueWithIdentifier("mainVCToSettings", sender: nil)
    }
    
    @IBAction func moveAddObjectView(sender: UIBarButtonItem) {
        if roomViewHasExpanded {
            
            performSegueWithIdentifier("addDeviceSegue", sender: self)
        }
        else {
            performSegueWithIdentifier("addRoomSegue", sender: self)
        }
    }
    
    func updateInterface() {
        
        roomInfoScrollView.frame = CGRectMake(view.frame.size.width, 0, view.frame.size.width, view.frame.size.height - 84)
        
        let houseSummaryView = UIView(frame: CGRectMake(10, 10, view.frame.size.width - 20, view.frame.size.height - 94))
        
        houseSummaryView.backgroundColor = UIColor.whiteColor()
        
        houseSummaryView.clipsToBounds = true
        
        houseSummaryView.layer.cornerRadius = (view.frame.size.width * 2 / 3 - 20) / 10
        
        
        
        controllerScrollView.addSubview(houseSummaryView)
        
        let houseImageView = UIImageView(frame: CGRectMake(0, 0, houseSummaryView.frame.size.width, houseSummaryView.frame.size.width / 2))
        
        
        houseImageView.image = UIImage(named: "houseIcon")
        
        if loadImageFromPath(saveDir.stringByAppendingPathComponent("housePhoto.png")) != nil {
            houseImageView.image = loadImageFromPath(saveDir.stringByAppendingPathComponent("housePhoto.png"))
        }
            
        else {
            houseImageView.image = UIImage(named: "houseIcon")
        }
        
        houseImageView.backgroundColor = UIColor.redColor()
        
        houseSummaryView.addSubview(houseImageView)
        
        let addressLabel = UILabel(frame: CGRectMake(10, houseImageView.frame.size.height + 10, houseSummaryView.frame.size.width - 20, 40))
        
        
        addressLabel.text = userInfoDefaults.stringForKey("userAddress")
        
        addressLabel.adjustsFontSizeToFitWidth = true
        
        addressLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 74)
        
        addressLabel.numberOfLines = 2
        
        houseSummaryView.addSubview(addressLabel)
        
        
        pageControl.numberOfPages = 2
        
        let contentOffset = controllerScrollView.contentOffset.x
        
        pageControl.currentPage = Int(contentOffset / view.frame.size.width)
        
        
        
        roomInfoScrollView.frame = CGRectMake(view.frame.size.width, 0, view.frame.size.width, view.frame.size.height - 84)
        
        controllerScrollView.addSubview(roomInfoScrollView)
        
        controllerScrollView.contentSize = CGSizeMake(view.frame.size.width * 2, view.frame.size.height - 20 - 44)
        
        var error2: NSError?
        
        let filesInDirectory: [String]! = fileManager.contentsOfDirectoryAtPath(saveDir, error: &error2) as? [String]
        
        
        csvFilesArray = []
        for i in filesInDirectory {
            let fileNameArray = i.componentsSeparatedByString(".")
            let fileEnd = fileNameArray[fileNameArray.count - 1]
            if fileEnd == "csv" {
                csvFilesArray += [i]
            }
        }
        
        elementsNum = count(csvFilesArray)
        
        let roomStatsLabel = UILabel(frame: CGRectMake(10, houseImageView.frame.size.height + 10 + addressLabel.frame.size.height + 20, houseSummaryView.frame.size.width - 20, 18))
        
        roomStatsLabel.text = "\(count(csvFilesArray)) rooms"
        
        roomStatsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        
        houseSummaryView.addSubview(roomStatsLabel)
        
        let applianceSummaryLabel = UILabel(frame: CGRectMake(10, houseImageView.frame.size.height + 50 + addressLabel.frame.size.height + roomStatsLabel.frame.size.height, houseSummaryView.frame.size.width, 20))
        
        var applianceCounter = 0
        
        applianceSummaryLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        
        houseSummaryView.addSubview(applianceSummaryLabel)
        
        let contentHeight = view.frame.size.width * 2 / 3 * CGFloat(count(csvFilesArray)) - 10
        let contentWidth: CGFloat = 0
        roomInfoScrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        
        var houseCost = 0.0
        
        if count(csvFilesArray) > 0 {
            for n in 0..<count(csvFilesArray) {
                
                let constantHeight = view.frame.size.width * 2 / 3
                
                let basicInfoView = UIView(frame: CGRectMake(10, constantHeight * CGFloat(n) + 10, view.frame.size.width - 20, constantHeight - 20))
                
                basicInfoView.clipsToBounds = true
                
                
                basicInfoView.backgroundColor = UIColor.whiteColor()
                
                basicInfoView.layer.cornerRadius = basicInfoView.frame.size.height / 10
                
                let roomTitleLabel = UILabel(frame: CGRectMake(10, 10, basicInfoView.frame.size.width * 2 / 3, 20))
                
                roomTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
                
                let fileArray = undoCSV(saveDir.stringByAppendingPathComponent(csvFilesArray[n]))
                
                roomTitleLabel.text = fileArray[0][0]
                
                basicInfoView.addSubview(roomTitleLabel)
                
                let roomImageView = UIImageView(frame: CGRectMake(basicInfoView.frame.size.width * 7 / 12, 0, basicInfoView.frame.size.width * 5 / 12, basicInfoView.frame.size.height))
                
                
                roomImageView.contentMode = .ScaleAspectFill
                
                roomImageView.clipsToBounds = true
                
                roomImageView.image = loadImageFromPath(saveDir.stringByAppendingPathComponent(fileArray[0][1]))
                
                basicInfoView.addSubview(roomImageView)
                
                let expandTapRecognizer = UITapGestureRecognizer(target: self, action: "expandRoomView:")
                
                basicInfoView.addGestureRecognizer(expandTapRecognizer)
                
                basicInfoView.tag = n + 1
                
                var devicesCounter = 0
                
                var totalRoomCost = 0.0
                
                var rowForImages: CGFloat = -1
                
                let imageSize = basicInfoView.frame.size.width / 2
                
                let deviceImageCollective = UIScrollView(frame: CGRectMake(0, basicInfoView.frame.size.height, basicInfoView.frame.size.width, roomInfoScrollView.frame.size.height - 10 - basicInfoView.frame.size.height))
                
                
                for l in 1..<count(fileArray) {
                    
                    
                    var price = 0.0
                    if fileArray[l][7] == "Air Conditioners" {
                        let hoursUsed = (fileArray[l][8] as NSString).doubleValue
                        price = (fileArray[l][5] as NSString).doubleValue * userInfoDefaults.doubleForKey("userElectricityPrice") * hoursUsed / 24
                        
                    }
                        
                    else {
                        //userInfoDefaults.doubleForKey("userElectricityPrice") * ((fileArray[l][5] as NSString).doubleValue) * userInfoDefaults.doubleForKey("period")
                        let hoursUsed = (fileArray[l][8] as NSString).doubleValue
                        price = ((fileArray[l][5] as NSString).doubleValue) / 365 * userInfoDefaults.doubleForKey("userElectricityPrice") * userInfoDefaults.doubleForKey("period") * hoursUsed / 24
                        
                        
                        //let kiloWatts = (fileArray[l][5] as NSString).doubleValue / 8760
                        
                        
                    }
                    
                    let applianceCost = price
                    
                    var error: NSError?
                    
                    let savePathContents: [String]! = fileManager.contentsOfDirectoryAtPath(saveDir, error: &error) as? [String]
                    
                    if devicesCounter % 2 == 0 {
                        rowForImages++
                    }
                    
                    
                    let deviceImageView = UIImageView(frame: CGRectMake(imageSize * CGFloat(devicesCounter % 2) + 2, imageSize * rowForImages + 2, imageSize - 4, imageSize - 4))
                    
                    let modelNumber = "".join(fileArray[l][0].componentsSeparatedByString("/"))
                    
                    deviceImageView.image = loadImageFromPath(saveDir.stringByAppendingPathComponent(fileArray[l][count(fileArray[l]) - 1]))
                    
                    deviceImageCollective.backgroundColor = UIColor(red: 224/256, green: 224/256, blue: 224/256, alpha: 1)
                    
                    let applianceLabel = UILabel(frame: CGRectMake(0, 0, deviceImageView.frame.size.width, 20))
                    
                    applianceLabel.text = fileArray[l][7]
                    
                    applianceLabel.textColor = UIColor.whiteColor()
                    
                    deviceImageView.addSubview(applianceLabel)
                    
                    let priceLabel = UILabel(frame: CGRectMake(0, deviceImageView.frame.size.height - 20, deviceImageView.frame.size.width, 20))
                    
                    priceLabel.textColor = UIColor.whiteColor()
                    
                    priceLabel.textAlignment = .Right
                    
                    priceLabel.text = "\(round(applianceCost * 100) / 100)"
                    
                    deviceImageView.addSubview(priceLabel)
                    
                    deviceImageView.contentMode = .ScaleAspectFill
                    
                    deviceImageView.clipsToBounds = true
                    
                    deviceImageView.tag = devicesCounter
                    
                    deviceImageCollective.addSubview(deviceImageView)
                    
                    
                    basicInfoView.addSubview(deviceImageCollective)
                    
                    totalRoomCost += applianceCost
                    houseCost += applianceCost
                    devicesCounter++
                    applianceCounter++
                }
                
                deviceImageCollective.contentSize.height = rowForImages * imageSize
                
                let devicesLabel = UILabel(frame: CGRectMake(10, roomTitleLabel.frame.size.height + 10 + 10, view.frame.size.width, 20))
                
                devicesLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
                
                devicesLabel.textColor = UIColor.grayColor()
                
                devicesLabel.text = "\(devicesCounter) Appliances"
                
                basicInfoView.addSubview(devicesLabel)
                
                
                let totalCostOfRoomLabel = UILabel(frame: CGRectMake(10, basicInfoView.frame.size.height - 55, basicInfoView.frame.size.width * 2 / 3, 55))
                
                totalCostOfRoomLabel.textColor = UIColor.grayColor()
                
                totalCostOfRoomLabel.adjustsFontSizeToFitWidth = true
                
                totalCostOfRoomLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 45)
                
                totalCostOfRoomLabel.text = "$\(round(100 * totalRoomCost) / 100)\nper period"
                
                
                
                
                basicInfoView.addSubview(totalCostOfRoomLabel)
                
                roomInfoScrollView.addSubview(basicInfoView)
                
            }
            
        }
            
        else {
            
            let noRoomsLabel = UILabel(frame: CGRectMake(view.frame.size.width / 4, 0, view.frame.size.width / 2, view.frame.size.height / 2))
            
            
            noRoomsLabel.text = "You haven't added any rooms yet. Tap the '+' button to get started."
            
            noRoomsLabel.numberOfLines = 0
            
            noRoomsLabel.textColor = UIColor.grayColor()
            
            noRoomsLabel.textAlignment = .Center
            
            roomInfoScrollView.addSubview(noRoomsLabel)
        }
        
        applianceSummaryLabel.text = "\(applianceCounter) Appliances"
        
        let totalHouseCostLabel = UILabel(frame: CGRectMake(10, houseSummaryView.frame.size.height - 100, houseSummaryView.frame.size.width - 20, 100))
        
        totalHouseCostLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 60)
        
        totalHouseCostLabel.textAlignment = .Right
        
        totalHouseCostLabel.text = "$\(round(100 * houseCost) / 100)"
        
        houseSummaryView.addSubview(totalHouseCostLabel)
        
        controllerScrollView.addSubview(roomInfoScrollView)
        
    }
    
    func activateDeleteRoom(sender: UIButton) {
        
        var error: NSError?
        
        var userInfoDefaults = NSUserDefaults.standardUserDefaults()
        
        var savePathContents: [String]! = fileManager.contentsOfDirectoryAtPath(saveDir, error: &error) as? [String]
        
        let fileNameToDelete = csvFilesArray[currentOpenView - 1]
        
        for i in savePathContents {
            let fileBeginner = fileNameToDelete.componentsSeparatedByString(".")[0]
            if i.hasPrefix(fileNameToDelete) {
                deleteFile(saveDir.stringByAppendingPathComponent(i))
            }
                
            else if i == "\(fileBeginner).png" {
                deleteFile(saveDir.stringByAppendingPathComponent(i))
            }
        }
        
        savePathContents = fileManager.contentsOfDirectoryAtPath(saveDir, error: &error) as? [String]
        
        
        let numOfCSVFiles = count(csvFilesArray)
        csvFilesArray = []
        
        for fileName in savePathContents {
            if fileName.hasSuffix(".csv") {
                csvFilesArray += [fileName]
            }
        }
        
        
        
        elementsNum--
        UIView.animateWithDuration(0.5) {
            self.roomInfoScrollView.viewWithTag(self.currentOpenView)?.frame.origin.x = self.view.frame.size.width + 20
            self.roomInfoScrollView.viewWithTag(self.currentOpenView)?.alpha = 0
            let contentOffset = CGFloat(self.currentOpenView - 1) * (self.view.frame.size.width * 2 / 3)
            self.roomInfoScrollView.contentOffset.y = contentOffset
            
            
            self.roomInfoScrollView.contentSize.height = CGFloat(self.elementsNum) * (self.view.frame.size.width * 2 / 3) - 10
        }
        if currentOpenView != numOfCSVFiles {
            for n in currentOpenView + 1...numOfCSVFiles {
                UIView.animateWithDuration(0.5) {
                    self.roomInfoScrollView.viewWithTag(n)?.frame.origin.y -= self.roomInfoScrollView.frame.size.height + 10
                }
            }
        }
        roomViewHasExpanded = false
        
        homeTitleBar.leftBarButtonItem = UIBarButtonItem(image:UIImage(named: "settingsIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "moveToSettingsPane")
        
        roomInfoScrollView.scrollEnabled = true
        
        //retag
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            for view in self.roomInfoScrollView.subviews {
                view.removeFromSuperview()
            }
            
            self.updateInterface()
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let contentOffset = controllerScrollView.contentOffset.x
        
        pageControl.currentPage = Int(contentOffset / view.frame.size.width)
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        return image
        
    }
    
    func undoCSV(filePath: String) -> [[String]] {
        
        let contentsOfFile = NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil) as! String
        
        var array1: [String] = contentsOfFile.componentsSeparatedByString("\n")
        
        var returnArray: [[String]] = []
        
        var isInQuotes = false
        
        var quoteResetNum = 0
        
        for i in array1 {
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
        
        return returnArray
    }
    
    
    func deleteFile(path: String) {
        var error: NSError?
        
        fileManager.removeItemAtPath(path, error: &error)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func viewContents(fileName: String) -> String {
        let path = saveDir.stringByAppendingPathComponent(fileName)
        let contentsOfFile = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        return contentsOfFile as! String
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addDeviceSegue" {
            var svc = segue.destinationViewController as! AddDeviceViewController
            
            var error: NSError?
            
            let savePathContents: [String]! = fileManager.contentsOfDirectoryAtPath(saveDir, error: &error) as? [String]
            
            svc.selectedRoom = csvFilesArray[currentOpenView - 1]
        }
    }
    
}