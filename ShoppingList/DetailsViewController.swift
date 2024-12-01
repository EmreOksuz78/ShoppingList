//
//  DetailsViewController.swift
//  ShoppingList
//
//  Created by EMRE ÖKSÜZ on 30.11.2024.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
        
    
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context) as! Shopping
    
        shopping.setValue(nameTextField.text, forKey: "name")
        shopping.setValue(sizeTextField.text, forKey: "size")
        
        if let price = Int(priceTextField.text!){
            shopping.setValue(price, forKey: "price")
        }
        
        shopping.setValue(UUID(), forKey:"id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        
        shopping.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("Saved data")
        } catch {
            print("Error saving data: \(error)")
        }
        
    }
    
    

}
