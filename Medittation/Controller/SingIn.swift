//
//  SingIn.swift
//  Medittation
//
//  Created by Алина Матюха on 26.11.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class SingIn: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func singInAction(_ sender: UIButton) {
        //проверяем пустые ли поля (isEmpty - проверяет содержится что-то или нет, empty - пусто)
        guard !email.text!.isEmpty || !password.text!.isEmpty else {return notifyScreen("Поля пустые, заполните поля для ввода")}
        guard !email.text!.isEmpty else {return notifyScreen("Введите почту")}
        guard !password.text!.isEmpty else {return notifyScreen("Введите пароль")}
        guard isValidEmail() else {return notifyScreen("Неверный формат электронной почты")}
        requestApi()

    }
    
    //функция запрашиает данные с апи
    private func requestApi() {
        
        let param: [String: String] = [
            "email": email.text!,
            "password": password.text!]
        
        AF.request(AppDelegate().baseUrl + "user/login", method: .post, parameters: param, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(let data):
                self.parseJSON(data!)
                
            case .failure(let error):
                self.notifyScreen(error.localizedDescription)
            }
        }
    }
    
    //функция берет данные с базы
    private func parseJSON(_ data: Data) {
        let json = JSON(data)
        let token = json["token"].stringValue
        let username = json["nickName"].stringValue
        let avatar = json["avatar"].stringValue
        userDefault.set(token, forKey: "token")
        userDefault.set(username, forKey: "nickName")
        userDefault.set(avatar , forKey: "avatar")
        performSegue(withIdentifier: "mainSegue", sender: nil )
    }
    
    //функция проверяет правильность введенной почты
    //2,64 - количество символов. мин 2, макс 64
    private func isValidEmail() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+//.[A-Za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHED %@", regEx)
        return pred.evaluate(with: email.text)
    }
    
    //всплывающее окно уведомления о пустых полях
    private func notifyScreen(_ message: String) {
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
