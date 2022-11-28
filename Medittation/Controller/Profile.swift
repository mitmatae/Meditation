//
//  Profile.swift
//  Medittation
//
//  Created by Алина Матюха on 26.11.2022.
//

import UIKit
import Foundation
import RealmSwift


class Profile: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
    let imagePicker = UIImagePickerController()
    let userDefault = UserDefaults.standard
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        userPicture.layer.cornerRadius = userPicture.frame.size.height / 2
        
        let avatar = userDefault.string (forKey: "avatar")
        userPicture.layer.cornerRadius = userPicture.frame.size.height / 2
        if let data = try? Data(contentsOf: URL (string: avatar!)!){
            userPicture.image = UIImage(data: data)}
        let name = userDefault.string(forKey: "nickName")
        userName.text = name
    }
    
    //кнопка выход из профиля удаляет токен и выводит на экран авторизации
    @IBAction func signOutAction(_ sender: UIButton) {
        userDefault.removeObject(forKey: "token")
        if userDefault.string(forKey: "token") == nil { return}
        performSegue(withIdentifier: "signOutSegue", sender: nil)
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realm.objects(Photo.self).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < realm.objects(Photo.self).count {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.picture.image = UIImage(data: realm.objects(Photo.self)[indexPath.row].photoData!)
        cell.time.text = realm.objects(Photo.self)[indexPath.row].time

            return cell}
        else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addPhotoCell", for: indexPath)
        
        return cell
    }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickerImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let date = DateFormatter()
        date.dateFormat = "HH:mm"
        let dateString = date.string(from: NSDate.now)
        
        let photo = Photo ()
        photo.photoData = pickerImage.jpegData(compressionQuality: 0.7)
        photo.time = dateString
        
        try! realm.write {
            realm.add(photo)
        }
        photoCollection.reloadData()
        self.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    @IBAction func insertNewPhotoAction(_ sender: UIButton){
        present(imagePicker, animated: true)
    }
}
