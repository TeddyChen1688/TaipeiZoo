//
//  FavoriteTableViewController.swift
//  TaipeiZoo
//
//  Created by eva on 2018/5/30.
//  Copyright © 2018年 Teddy Chen. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var favorite: FavoriteMO!
    @IBOutlet weak var nameTextField: RoundedTextField!{
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!{
        didSet {
            descriptionTextView.tag = 2
            //descriptionTextField.delegate = self
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!{
        didSet {
            photoImageView.layer.cornerRadius = 2
            photoImageView.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    // MARK: - UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let photoSourceRequestController = UIAlertController(title: "", message: "拍照 or 相簿", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "拍照", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            let photoLibraryAction = UIAlertAction(title: "相簿", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in }
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction) //加入 cancel 按鈕
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let compressedImage = resize(selectedImage)
            photoImageView.image = compressedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true

        }
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func compressImage (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1024.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    
    // MARK: - UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    // MARK: - Action method (Exercise #2)
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if nameTextField.text == "" || descriptionTextView.text == "" || photoImageView.image == nil {
            let alertController = UIAlertController(title: "等一下", message: " 呵呵, 要填完才上傳喔! ", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        print("Name: \(nameTextField.text ?? "")")
        print("Description: \(descriptionTextView.text ?? "")")
        
        // Saving the restaurant to database
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            favorite = FavoriteMO(context: appDelegate.persistentContainer.viewContext)
            favorite.name = nameTextField.text
            favorite.summary = descriptionTextView.text
            // favorite.isVisited = false
            favorite.isVisited = photoImageView.isHighlighted ? false : true
            
            let now = Date ()
            let postDate = Double(round(now.timeIntervalSince1970 * 1000))
            favorite.postDate = postDate
            print("favorite.postDate: \(favorite.postDate)")
          //  photoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2*3))

            if let favoriteImage = photoImageView.image {
                favorite.image = UIImagePNGRepresentation(favoriteImage)! as NSData
            }
            // print("Saving data to context ...")
            appDelegate.saveContext()
        }
        
        UserDefaults.standard.set(true, forKey: "hasSaveNewUserDataToDataStore")
        dismiss(animated: true, completion: nil)
    }
}
