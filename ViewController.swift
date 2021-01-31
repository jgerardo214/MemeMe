//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Jonathan Gerardo on 1/23/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
  
    @IBOutlet weak var navigationBar: UIToolbar!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    let memeAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black ,
        NSAttributedString.Key.foregroundColor: UIColor.white ,
        NSAttributedString.Key.font: UIFont(name: "Futura", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
        
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.topTextField.defaultTextAttributes = memeAttributes
        self.bottomTextField.defaultTextAttributes = memeAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if textField.text == "TOP" {
                topTextField.text = ""
            } else if bottomTextField.text == "BOTTOM" {
                bottomTextField.text = ""
            }
            return true
        }
        
        func textfieldShouldReturn(_ textField: UITextField) -> Bool {
            return textField.resignFirstResponder()
        }
        
        
        
    }
    
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    //MARK: Keyboard Functions
    
    // Setup keyboard funcitons to be able to edit the textfields without being in the way
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
        //MARK: Image Picker Functions
    
    @IBAction func imageSelected(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
        
      
    }
    
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            
    }
        self.dismiss(animated: true, completion: nil)
        shareButton.isEnabled = true
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func shareImagePressed(_ sender: Any) {
        let sharedImage = generateMeme()
        let controller = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed && error == nil {
                self.saveImage()
            }
        }
        controller.isModalInPresentation = true
        present(controller, animated: true, completion: nil)
        
        
    }
    
    
    func saveImage() {
        _ = Meme(topText: topTextField.text!,
                 bottomText: bottomTextField.text!,
                 originalImage: imagePickerView.image!,
                 memedImage: imagePickerView.image!)
        
        
    }
    
    func resetImages() {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    

    
    @IBAction func cancelMeme(_ sender: Any) {
        resetImages()
        
    }
    
    
    func generateMeme() -> UIImage {
        
        
        //hide toolbars//
                self.navigationBar.isHidden = true
                self.toolBar.isHidden = true
                //render to viewer//
                UIGraphicsBeginImageContext(self.view.frame.size)
                view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
                // Show toolbar
                self.navigationBar.isHidden = false
                self.toolBar.isHidden = false
                let memeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsGetCurrentContext()
                return memeImage
    }
    
    

    
    
    @IBAction func pickImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
}


