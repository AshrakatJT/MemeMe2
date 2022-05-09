//
//  ViewController.swift
//  MemeMe2
//
//  Created by Ashrakat Sherif on 08/10/2021.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var activeTextField: UITextField?
    var sentTopText:String?
    var sentBottomText:String?
    var sentImage:UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        if (self.sentImage != nil){
            self.imagePickerView.image = self.sentImage
        }
        
        if (self.sentTopText != nil){
            self.topTextField.text = self.sentTopText!
        }
        
        if (self.sentBottomText != nil){
            self.bottomTextField.text = self.sentBottomText!
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyboardNotifications()
    }
    

    override func viewDidLoad() {
        
        let tapAnywhere = UITapGestureRecognizer(target: self, action: #selector(self.dismiss(animated:completion:)))
        self.view.addGestureRecognizer(tapAnywhere)
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        prepareTextField(topTextField)
        prepareTextField(bottomTextField)
        shareButton.isEnabled = false
        
        if sentTopText != nil && sentBottomText != nil && sentImage != nil{
            topTextField.text = sentTopText
            bottomTextField.text = sentBottomText
            imagePickerView.image = sentImage
        }
    }
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar:UIToolbar!
    
    
        @IBAction func pickImageViaCamera(_ sender: Any) {
        pickAnImage(source: .camera)
       }
    
   
   @IBAction func pickImageViaAlbum(_ sender: Any) {
    pickAnImage(source: .photoLibrary)
    }
    
    @IBAction func shareAnImage(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func doneToShareMeme(_ sender: Any) {
       
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func topTextField(_ sender: Any) {
        textFieldDidBeginEditing(topTextField)
    }
    
    @IBAction func bottomTextField(_ sender: Any) {
        textFieldDidBeginEditing(bottomTextField)
    }
    
    func prepareTextField(_ textfield: UITextField){
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        if textfield == topTextField && topTextField.text == ""{
            textfield.text = "TOP"
        }
        if textfield == bottomTextField && bottomTextField.text == ""{
            bottomTextField.text = "BOTTOM"
        }
    }
    
    func pickAnImage(source: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
            present(pickerController, animated: true, completion: nil)

        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image Selected")
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
    }
        else if let editedImage = info[.editedImage] as? UIImage{
            imagePickerView.image = editedImage
        }
        shareButton.isEnabled = true
        print ("Share button action is active")
        dismiss(animated:true, completion: nil)
    
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
       dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField:UITextField){
        if (textField == topTextField && textField.text == "TOP") || (textField == bottomTextField && textField.text == "BOTTOM"){
            textField.text = " "
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor:UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2.0
    ]

    
    
    @objc func keyboardWillShow(_ notification:Notification){
        if bottomTextField.isFirstResponder {
        view.frame.origin.y = -getKeyboardHeight (notification)
    }
    }
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func save() {
        
        let meme = Meme (topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        print (appDelegate.memes.count)
    }

    
    func generateMemedImage() -> UIImage {
        bottomToolBar.isHidden = true
        topToolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        bottomToolBar.isHidden = false
        topToolBar.isHidden = false
        return memedImage
    }
    
    func showMemeInBetween() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        
        initialState()
    }
   
    func initialState() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
    }

}





