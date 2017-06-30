//
//  PostScreenViewController.swift
//  PYT
//
//  Created by osx on 27/06/17.
//  Copyright © 2017 osx. All rights reserved.
//

import UIKit
import DKImagePickerController
class PostScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addImg1: UIButton!
    @IBOutlet weak var addImg2: UIButton!
    @IBOutlet weak var addImg3: UIButton!
    @IBOutlet weak var addImg4: UIButton!
    @IBOutlet weak var addImg5: UIButton!
    @IBOutlet weak var addImg6: UIButton!
    @IBOutlet weak var addImg7: UIButton!
    @IBOutlet weak var addImg8: UIButton!
    
    
    @IBOutlet weak var deleteImg1: UIButton!
    @IBOutlet weak var deleteImg2: UIButton!
    @IBOutlet weak var deleteImg3: UIButton!
    @IBOutlet weak var deleteImg4: UIButton!
    @IBOutlet weak var deleteImg5: UIButton!
    @IBOutlet weak var deleteImg6: UIButton!
    @IBOutlet weak var deleteImg7: UIButton!
    @IBOutlet weak var deleteImg8: UIButton!
    
    
    
    //Amasone server
    let S3UploadKeyName: String = "iqtBkg8alWc0rdsXXoxF6aMc9VJPWROfDDOj3TOd"
    let amazoneUrl = "https://s3-us-west-2.amazonaws.com/"
    let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"//live
    let S3BucketName = "pytphotobucket"//live
    
    
    /////
    var imageData = Data()
    var isCamera = Bool()
    var multipleImagesArray = NSMutableArray()
    var originalArray = NSMutableArray()
    var thumbnailArray = NSMutableArray()
    var boolCount = Int()
    var accessPhoto = String()
    var catSelectedId = NSMutableArray()
    var editImagesArray = NSMutableArray()//Edit photos
    //Image Picker
    let imagePicker = UIImagePickerController()
    
    
    //var pickerController: DKImagePickerController!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEmptyImageInbuttons()
        
        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    
    
    
    @IBAction func actionSheet(_ sender: AnyObject)
    {
        
        print(sender.tag)
        
        if sender.imageView??.image == UIImage( named: "SmallImagethumb") {
            self.openActionSheet()
        }
        else
        {
            self.setBigImageInMiddle(senderImg: (sender.imageView??.image)!)
        }
        
    }
    
    
    func openActionSheet() {
        
        
         imagePicker.delegate = self
            
            let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let libAction = UIAlertAction(title: "Select from library", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
                //self.photofromLibrary()
                
            })
            
            let captureAction = UIAlertAction(title: "Capture image", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.capture()
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
            
            alertController.addAction(libAction)
            alertController.addAction(captureAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion:{})
        
        
        
    }
    
    
    
    
    //MARK: Image Picker Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        if multipleImagesArray.count<7
        {
            var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage!
            var finalImage = UIImage()
            finalImage=chosenImage!
            var uploadImg = UIImage()
            
            if Int((chosenImage?.size.width)!) > 1500 {
                
                finalImage =  scaleImage(chosenImage!, toSize: CGSize(width: 1500, height: 1300))
                
                uploadImg = scaleImage(chosenImage!, toSize: CGSize(width: 1500, height: 1300))
                imageData = UIImageJPEGRepresentation(uploadImg,0.2)!
                
                // print(imageData.bytes)
                
                
            }
            else
            {
                imageData = UIImageJPEGRepresentation(chosenImage!,0.2)!
                //print(imageData.bytes)
            }
            
            
            chosenImage = finalImage
            
            
            
            
            let testImgView = UIImageView()
            testImgView.image=self.scaleImage(chosenImage!, toSize: CGSize(width:350, height: 300))
            
            self.multipleImagesArray .add(["imageData": imageData, "originalImage":chosenImage, "urlImg":"camera", "thumbnail": testImgView.image! ])
            
            
            
            
            
            
            
            
            
            
            print("original=\(chosenImage), other=\(testImgView.image)")
            
            
            dismiss(animated: true, completion: nil)
            
            
            
            
            
        }
            
        else
        {
            dismiss(animated: true, completion: nil)
            CommonFunctionsClass.sharedInstance().showAlert(title: "Too much to handle!", text: "You can't add more than eight pictures at once.", imageName: "alertLimit")
            
            
            
        }
        
        
    }
    
    
    
  
    
    //open capera to click photos
    func capture() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
    func photofromLibrary() {
        
        
      // let pickerController: DKImagePickerController!
         var assets: [DKAsset]?
        
        
        
       // pickerController.didSelectAssets = { (assets: [DKAsset]) in
           // print("didSelectAssets")
            //print(assets)
            
        //}
        
        pickerController.didCancel = { ()
            print("didCancel")
        }
        
        pickerController.didSelectAssets = { [unowned self] (assets2: [DKAsset]) in
            print("didSelectAssets")
            
            assets = assets2
        }
        
        
        
        
        
        self.present(pickerController, animated: true) {}
        
        pickerController.allowMultipleTypes=false
        pickerController.assetType = .allPhotos
        pickerController.maxSelectableCount = 8 - self.multipleImagesArray.count
        
        
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
        
            
            
            
           // dispatch_async(dispatch_get_main_queue()) {
                
                
            
                
                
                
                for asset in assets {
                    
                    
                    asset.fetchOriginalImage(false, completeBlock: { image, info in
                        
                        if let img = image{
                            print(img)
                            
                            let dictInfo:NSDictionary = info! as NSDictionary
                            
                            let urlImg = dictInfo.value(forKey: "PHImageFileURLKey")
                            
                            
                            var uploadImg = UIImage()
                            
                            if img.size.width>1200 {
                                
                                
                                print("Going Inside")
                                
                                uploadImg = self.scaleImage(img, toSize: CGSize(width: 1500, height: 1300))
                                self.imageData = UIImageJPEGRepresentation(uploadImg,0.2)!
                                
                                print(self.imageData.count/1024/1024)
                                
                                
                            }
                            else
                            {
                                self.imageData = UIImageJPEGRepresentation(img,0.2)!
                                print(self.imageData.count/1024/1024)
                            }
                            
                            
                            
                            let testImgView = UIImageView()
                            testImgView.image=self.scaleImage(img, toSize: CGSize(width:300, height: 250))
                            
                            
                            
                            if self.multipleImagesArray.count<8 {
                                
                                let imArr = self.multipleImagesArray.value(forKey: "urlImg") as! NSArray
                                if imArr.contains(urlImg!)
                                {
                                    
                                    print("already contains")
                                    
                                }
                                else{
                                    self.multipleImagesArray .add(["imageData": self.imageData, "originalImage":img, "urlImg": urlImg!, "thumbnail": testImgView.image!])
                                    
                                }
                                
                                
                                
                                
                            }
                            
                           
                            
                        }
                        
                        
                        
                        
                        
                    
                        
                        
                    })
                    
                }
           // }
            
            
        }
        
        
        
        
        
        
    }
    */
    
    
    
    
    
    //MARK: Delete selected images
    
    //Remove image target from collectionView
    
    @IBAction func deleteImageAction(_ sender: AnyObject)
    {
        self.multipleImagesArray .removeObject(at: sender.tag)
    }

    
    
    //MARK: Function to scale image according to height and width and its ratio..
    func scaleImage(_ image: UIImage, toSize newSize: CGSize) -> UIImage {
        var scaledSize:CGSize = newSize
        var scaleFactor: Float = 1
        if image.size.width > image.size.height {
            scaleFactor = Float(image.size.width / image.size.height)
            scaledSize.width = newSize.width
            scaledSize.height =  newSize.height / CGFloat(scaleFactor)
        }
        else {
            scaleFactor = Float(image.size.height / image.size.width)
            scaledSize.height = newSize.height
            scaledSize.width = newSize.width / CGFloat(scaleFactor)
        }
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        let scaledImageRect = CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height)
        image.draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    
    
    //MARK: Set images in the button
    func setImageInButtons(btntag: Int) {
        //imageToPost.imageView?.contentMode = .scaleAspectFill
        // imageToPost.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        switch btntag {
//        case 0:
//            let imageBtn = self.scaleImage(((self.multipleImagesArray.object(at: btntag) as AnyObject).value(forKey: "originalImage"))  as! UIImage, toSize: addImg1.frame.size)
//            addImg1.setImage(imageBtn, for: .normal)
//            deleteImg1.isHidden = false
//            break
            
        case 0:
            let imageBtn = self.scaleImage(self.multipleImagesArray.object(at: btntag) as! UIImage, toSize: addImg2.frame.size)
            addImg2.setImage(imageBtn, for: .normal)
            deleteImg2.isHidden = false
            break
            
        case 1:
            let imageBtn = self.scaleImage(self.multipleImagesArray.object(at: btntag) as! UIImage, toSize: addImg3.frame.size)
            addImg3.setImage(imageBtn, for: .normal)
            deleteImg3.isHidden = false
            break
            
        case 2:
            let imageBtn = self.scaleImage(self.multipleImagesArray.object(at: btntag) as! UIImage, toSize: addImg4.frame.size)
            addImg4.setImage(imageBtn, for: .normal)
            deleteImg4.isHidden = false
            break
            
        case 3:
            let imageBtn = self.scaleImage(self.multipleImagesArray.object(at: btntag) as! UIImage, toSize: addImg5.frame.size)
            addImg5.setImage(imageBtn, for: .normal)
            deleteImg5.isHidden = false
            break
            
        case 4:
            let imageBtn = self.scaleImage(self.multipleImagesArray.object(at: btntag) as! UIImage, toSize: addImg6.frame.size)
            addImg6.setImage(imageBtn, for: .normal)
            deleteImg6.isHidden = false
            break
            
        case 5:
            let imageBtn = self.scaleImage(self.multipleImagesArray.object(at: btntag) as! UIImage, toSize: addImg7.frame.size)
            addImg7.setImage(imageBtn, for: .normal)
            deleteImg7.isHidden = false
            break
            
        default:
            let imageBtn = self.scaleImage(self.multipleImagesArray.object(at: btntag) as! UIImage, toSize: addImg8.frame.size)
            addImg8.setImage(imageBtn, for: .normal)
            deleteImg8.isHidden = false
            break
        }
        
        
        
    }
    
    //Set initial Images in the Buttons
    func setEmptyImageInbuttons()
    {
        addImg1.setImage(UIImage (named: "Bigimagethumbpost"), for: .normal)
        addImg2.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg3.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg4.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg5.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg6.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg7.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        addImg8.setImage(UIImage (named: "SmallImagethumb"), for: .normal)
        
        addImg1.imageView?.contentMode = .scaleAspectFill
        addImg1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        deleteImg1.isHidden = true
        deleteImg2.isHidden = true
        deleteImg3.isHidden = true
        deleteImg4.isHidden = true
        deleteImg5.isHidden = true
        deleteImg6.isHidden = true
        deleteImg7.isHidden = true
        deleteImg8.isHidden = true
        
       // deleteImg1.tag = 0
        deleteImg2.tag = 0
        deleteImg3.tag = 1
        deleteImg4.tag = 2
        deleteImg5.tag = 3
        deleteImg6.tag = 4
        deleteImg7.tag = 5
        deleteImg8.tag = 6
        
        
        addImg2.tag = 0
        addImg3.tag = 1
        addImg4.tag = 2
        addImg5.tag = 3
        addImg6.tag = 4
        addImg7.tag = 5
        addImg8.tag = 6
    
    }
    
    
    
    func setBigImageInMiddle(senderImg: UIImage) {
        
        
       // let imageBtn = self.scaleImage(((self.multipleImagesArray.object(at: sender.tag) as AnyObject).value(forKey: "originalImage"))  as! UIImage, toSize: addImg1.frame.size)
                   addImg1.setImage(senderImg, for: .normal)
                   deleteImg1.isHidden = true
        
        
        
        
        
        
    }
    
    
    
    
    
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
