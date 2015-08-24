//
//  EditProfileViewController.swift
//  Orphee
//
//  Created by Jeromin Lebon on 19/08/2015.
//  Copyright © 2015 __ORPHEE__. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var nameProfile: UILabel!
    var gestureImageRecognizer: UITapGestureRecognizer!
    var imagePicker: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureImageRecognizer = UITapGestureRecognizer(target: self, action: "touchImg")
        imgProfile.addGestureRecognizer(gestureImageRecognizer)
        imgProfile.userInteractionEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController!.navigationBar.barTintColor = UIColor(red: (13/255.0), green: (71/255.0), blue: (161/255.0), alpha: 1.0)
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func touchImg(){
        let optionMenu = UIAlertController(title: nil, message: "Choisissez une option", preferredStyle: .ActionSheet)
        let deleteAction = UIAlertAction(title: "Prendre une photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .Camera
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Choisir une photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("cancel")
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let croppedImage: UIImage = ImageUtil().cropToSquare(image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        imgProfile.image = croppedImage
        UIImageWriteToSavedPhotosAlbum(imgProfile.image!, nil, nil, nil)
        saveImageToDirectory(imgProfile.image!)
    }
    
    func saveImageToDirectory(img: UIImage){
        let image = img
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        print(documentsPath)
        let destinationPath = documentsPath.stringByAppendingPathComponent("imgProfile.png")
        UIImageJPEGRepresentation(image,1.0)!.writeToFile(destinationPath, atomically: true)
        print(destinationPath)
    }
    
    @IBAction func validateButton(sender: AnyObject) {
        Alamofire.request(.GET, "http://163.5.84.242:3000/api/upload/image/png").responseJSON{request, response, json in
            print(request)
            print(response)
            print(json.value!)
            var newJson = JSON(json.value!)
            let headers = [
                "Content-Type":"image/png"
            ]
            let url = newJson["urlPut"].string!
            self.sendImgToAmazon(url, headers: headers)
        }
    }
    
    func sendImgToAmazon(url: String, headers: [String:String]){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let destinationPath = documentsPath.stringByAppendingPathComponent("imgProfile.png")
        Alamofire.upload(.PUT, url, headers: headers, file: NSURL(fileURLWithPath: destinationPath))
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
            }
            .responseJSON { request, response, result in
                debugPrint(result)
        }
    }
}