//
//  UploadVC.swift
//  SnapChat
//
//  Created by Can Kanbur on 6.04.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
class UploadVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadImageView.addGestureRecognizer(tabGesture)
    }
    
    
    
    @objc func chooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker,animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }

    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { data, error in
                if error != nil {
                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                }else{
                    
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                                }else{
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents{
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray  = document.get("imageUrlArray") as? [String]{
                                                imageUrlArray.append(imageUrl!)
                                                let addDictionary = ["imageUrlArray":imageUrlArray] as [String : Any]
                                                firestore.collection("Snaps").document(documentId).setData( addDictionary, merge: true) { error in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "selectimage.png")
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }else{
                                        let snapDic = ["imageUrlArray":[imageUrl!],"snapOwner":UserSingleton.sharedUserInfo.username,"date":FieldValue.serverTimestamp()]
                                        firestore.collection("Snaps").addDocument(data: snapDic) { error in
                                            if error != nil {
                                                self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                                            }else{
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(named: "selectimage.png")
                                            }
                                        }

                                        
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            
        }
            
            
        
        
    }
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true)
    }
    

}
