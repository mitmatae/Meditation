//
//  ViewController.swift
//  Medittation
//
//  Created by Алина Матюха on 24.11.2022.
//

import UIKit
import Alamofire
import SwiftyJSON


class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var collectionFeeling: UICollectionView!
    @IBOutlet weak var collectionQuote: UICollectionView!
    
    let userDefault = UserDefaults.standard
    
    struct Feeling {
        var title: String
        var image:String
        var position: String
    }
    
    var feelingCollection: [Feeling] = []
    
    struct Quote {
        var title: String
        var discription: String
        var picture: String
    }
    
    var quoteCollection: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInformation()
        requestFeeling()
        requestQuote()
    }
    
    //функция заменяет имя в приветствии на имя пользователя
    private func loadUserInformation() {
        let userName = userDefault.string(forKey: "nickName")
        titleLable.text = "С возвращением, \(userName ?? "user")!"
//берет картинку с базы и скругляет ее
        let avatar = userDefault.string(forKey: "avatar")
        userPicture.layer.cornerRadius = userPicture.frame.size.height / 2
        if let data = try? Data(contentsOf: URL(string: avatar!)!){
            userPicture.image = UIImage(data: data)}
    }

    func requestFeeling() {
        AF.request(AppDelegate().baseUrl + "feelings", method: .get).response { response in
            switch response.result {
            case .success(let value):
                self.parseFeeling(value!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func parseFeeling(_ data: Data) {
        let json = JSON(data)
        for item in 0..<json["data"].count{
        feelingCollection.append(Feeling(
            title: json["data"][item]["title"].stringValue,
            image: json["data"][item]["image"].stringValue,
            position: json["data"][item]["position"].stringValue))
        }
        feelingCollection.sort { $0.position < $1.position }
        collectionFeeling.reloadData()
    }
    
    func requestQuote() {
        AF.request(AppDelegate().baseUrl + "quotes", method: .get).response { response in
            switch response.result {
            case .success(let value):
                self.parseQuote(value!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func parseQuote(_ data: Data) {
        let json = JSON(data)
        for item in 0..<json["data"].count{
        quoteCollection.append(Quote(
            title: json["data"][item]["title"].stringValue,
            discription: json["data"][item]["discription"].stringValue,
            picture: json["data"][item]["picture"].stringValue))
        }
        
        collectionQuote.reloadData()
    }
    
    //количество элементов в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionQuote {
            return quoteCollection.count
        }
        
        return feelingCollection.count
    }
    
    //настройки ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionQuote {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quoteCell", for: indexPath) as! QuoteCell
            
            cell.name.text = quoteCollection[indexPath.row].title
            cell.desc.text = quoteCollection[indexPath.row].discription
            if let data = try? Data(contentsOf: URL(string: quoteCollection[indexPath.row].picture)!){
                cell.backroundImage.image = UIImage(data: data)}
            
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feelingCell", for: indexPath) as! FeelingCell
        cell.picture.layer.cornerRadius = cell.picture.frame.size.height / 3
        if let data = try? Data(contentsOf: URL(string: feelingCollection[indexPath.row].image)!){
            cell.picture.image = UIImage(data: data)}
        cell.subtitle.text = feelingCollection[indexPath.row].title
        
        return cell
    }

}

