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
    
    var selectedProductName = ""
    var selectedProductUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedProductName != ""{
            //Core Data show information of selected product
            
            if let uuidString = selectedProductUUID?.uuidString{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject]{
                            
                            if let name = result.value(forKey: "name") as? String {
                                nameTextField.text = name
                            }
                            
                            if let price = result.value(forKey: "price") as? Int{
                                priceTextField.text = String(price)
                            }
                            
                            if let size = result.value(forKey: "size") as? String{
                                sizeTextField.text = size
                            }
                            
                            if let imageData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: imageData)
                                imageView.image = image
                            }
                            
                        }
                        
                    }
                    
                }catch {
                    print("Error")
                }
                
                
            }
            
        }else{
            nameTextField.text = ""
            priceTextField.text = ""
            sizeTextField.text = ""
        }

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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataEntered"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

}
