//
//  RVApiManager.swift
//  ManagerDemo
//
//  Created by Rajat Vashisht on 6/8/18.
//  Copyright © 2018 Rajat. All rights reserved.
//
import Foundation
import Alamofire
import KRProgressHUD
import KRActivityIndicatorView

typealias RvCompletionHandler = ((_ result: Any?,_ Error: Error?) -> Void)?

//Base Url
let serverBaseURL = "http://www.themealdb.com/api/json/v1/1"
let googleAPIKey = "AIzaSyBGDxU-QAhIRIszPNtWMUGpqwz2U4_Qyls"

struct Apis{
    static let searchMeals = "search.php?s="
    static let randomMeals = "random.php"
}

class RVApiManager: NSObject {
    static let shared = RVApiManager()
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

extension RVApiManager {
    
    fileprivate func printAPI_Before(strURL:String = "", parameters:[String:Any] = [:], headers: HTTPHeaders = [:])
    {
        var str = "\(parameters)"
        str = str.replacingOccurrences(of: " = ", with: ":")
        str = str.replacingOccurrences(of: "\"", with: "")
        str = str.replacingOccurrences(of: ";", with: "")
        
        print("APi - \(strURL)\nParameters - \(str)\nHeaders - \(headers)")
    }
    
    fileprivate func printAPI_After(response :AFDataResponse<Any>)
    {
        if let value = response.value
        {
            print("result.value: \(value)") // result of response serialization
        }
        if let error = response.error
        {
            print("result.error: \(error)") // result of response serialization
        }
    }
    
    
    fileprivate func hitApi(_ apiUrl: String = "",
                            type: HTTPMethod = .post,
                            parameter: [String:Any] = [:],
                            Vc: UIViewController,
                            completionHandler : RvCompletionHandler
        ) {
        var strUrl : String = serverBaseURL
        if apiUrl.contains("http") {
            strUrl = ""
        }
        if !strUrl.isEmpty && !apiUrl.isEmpty {
            strUrl.append("/")
        }
        strUrl.append(apiUrl)
        
        let headers : HTTPHeaders = [:]
        RVApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameter, headers: headers)
        let api = AF.request(strUrl, method: type, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
        api.responseJSON { (responce) in
            RVApiManager.shared.printAPI_After(response: responce)
            if let JSON = responce.data, JSON.count > 0 {
                completionHandler!(JSON, nil)
            }
            else if let Error = responce.error {
                completionHandler!(nil,Error as Error )
            }
            else {
                completionHandler!(nil , NSError(domain: "error", code: 117, userInfo: nil))
            }
        } 
    }
    
    fileprivate func upLoadApi(_ apiUrl: String = "",
                               uploadObjects: [MultipartObject]?,
                               type: HTTPMethod = .post,
                               parameter : [String: Any] = [:],
                               Vc: UIViewController,
                               completionHandler: RvCompletionHandler
        ) {
        var strUrl : String = serverBaseURL
        if apiUrl.contains("http") {
            strUrl = ""
        }
        if !strUrl.isEmpty && !apiUrl.isEmpty {
            strUrl.append("/")
        }
        strUrl.append(apiUrl)
        
        var headers : HTTPHeaders = [:]
        RVApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameter, headers: headers)
        
      AF.upload(multipartFormData: { multipartFormData in
             for (key, value) in parameter {
                if let d = value as? [String : Any] {
                  do {
                    let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
                    multipartFormData.append(data, withName: key)
                  } catch {
                     
                  }
                } else {
                  multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
             }
             
             for data in uploadObjects! {
                 multipartFormData.append(data.dataObj, withName: data.strName, fileName: data.strFileName, mimeType: data.strMimeType)
             }
      }, to: strUrl, method: type, headers: headers)
        .responseJSON { response in
            debugPrint(response)
            
            print("Succesfully Updated")
            RVApiManager.shared.printAPI_After(response: response)
            if let JSON = response.data, JSON.count > 0 {
                completionHandler!(JSON, nil)
            }
            else if let Error = response.error {
                completionHandler!(nil,Error as Error )
            }
            else {
                completionHandler!(nil , NSError(domain: "error", code: 117, userInfo: nil))
            }
        }
    }
}

extension RVApiManager {
 
    class func getAPI <T: Decodable>(_ apiUrl: String = "", parameters : [String:Any] = [:], Vc: UIViewController, showLoader : Bool = true, completionHandler : @escaping (T)->()) {
        if RVApiManager.isConnectedToInternet {
            if showLoader {
                KRProgressHUD.show()
            }
            var strUrl : String = serverBaseURL
            if apiUrl.contains("http") {
                strUrl = ""
            }
            if !strUrl.isEmpty && !apiUrl.isEmpty {
                strUrl.append("/")
            }
            strUrl.append(apiUrl)
            var headers : HTTPHeaders = [:] // ["Content-Type" : "application/x-www-form-urlencoded"]
            RVApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters, headers : headers)
            let api = AF.request(strUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            
            api.responseJSON { (responce) in
                if showLoader {
                    KRProgressHUD.dismiss()
                }
                RVApiManager.shared.printAPI_After(response: responce)
                if let JSON = responce.data, JSON.count > 0 {
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: JSON)
                        completionHandler(obj)
                    }
                    catch let jsonError {
                        print("failed to download data", jsonError)
                    }
                }
                else if let Error = responce.error {
                    Vc.showAlert(message: Error.localizedDescription, strtitle: "Error")
                    
                }
                else {
                }
            }
            
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }
    
    class func deleteAPI <T: Decodable>(_ apiUrl: String = "", parameters : [String:Any] = [:], Vc: UIViewController, showLoader : Bool = true, completionHandler : @escaping (T)->()) {
        if RVApiManager.isConnectedToInternet {
            if showLoader {
                KRProgressHUD.show()
            }
            var strUrl : String = serverBaseURL
            if apiUrl.contains("http") {
                strUrl = ""
            }
            if !strUrl.isEmpty && !apiUrl.isEmpty {
                strUrl.append("/")
            }
            strUrl.append(apiUrl)
            var headers : HTTPHeaders = [:] // ["Content-Type" : "application/x-www-form-urlencoded"]
            RVApiManager.shared.printAPI_Before(strURL: strUrl, parameters: parameters, headers : headers)
            let api = AF.request(strUrl, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            
            api.responseJSON { (responce) in
                if showLoader {
                    KRProgressHUD.dismiss()
                }
                RVApiManager.shared.printAPI_After(response: responce)
                if let JSON = responce.data, JSON.count > 0 {
                    do {
                        let obj = try JSONDecoder().decode(T.self, from: JSON)
                        completionHandler(obj)
                    }
                    catch let jsonError {
                        print("failed to download data", jsonError)
                    }
                }
                else if let Error = responce.error {
                    Vc.showAlert(message: Error.localizedDescription, strtitle: "Error")
                    
                }
                else {
                }
            }
            
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }

    class func postAPI <T: Decodable>(_ apiUrl: String = "", parameters : [String:Any] = [:], Vc: UIViewController, showLoader : Bool = true, completionHandler : @escaping (T)->()) {
        if RVApiManager.isConnectedToInternet {
            if showLoader {
                KRProgressHUD.show()
            }
            RVApiManager.shared.hitApi(apiUrl, type: .post, parameter: parameters, Vc: Vc) { (result, error) in
                    if showLoader {
                        
                        KRProgressHUD.dismiss()
                    }
                guard error == nil else {
                    if showLoader {
                        KRProgressHUD.dismiss {
                            KRProgressHUD.showError(withMessage: (error?.localizedDescription)!)
                        }
                    }
                    return}
                guard let data = result else {return}
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data as! Data)
                    completionHandler(obj)
                }
                catch let jsonError  {
                    print("failed to download data", jsonError)
                }
            }
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }
    
    class func putAPI <T: Decodable>(_ apiUrl: String = "", parameters : [String:Any] = [:], Vc: UIViewController, showLoader : Bool = true, completionHandler : @escaping (T)->()) {
        if RVApiManager.isConnectedToInternet {
            if showLoader {
                KRProgressHUD.show()
            }
            RVApiManager.shared.hitApi(apiUrl, type: .put, parameter: parameters, Vc: Vc) { (result, error) in
                    if showLoader {
                        KRProgressHUD.dismiss()
                    }
                guard error == nil else {
                    if showLoader {
                        KRProgressHUD.dismiss {
                            KRProgressHUD.showError(withMessage: (error?.localizedDescription)!)
                        }
                    }
                    return}
                guard let data = result else {return}
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data as! Data)
                    completionHandler(obj)
                }
                catch let jsonError  {
                    print("failed to download data", jsonError)
                }
            }
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }
    
    class func postApiWithImage<T : Decodable >(_ apiUrl: String = "", image: UIImage, imageName: String,Vc: UIViewController, parameters : [String: Any] = [:],isAnimating : Bool = true, completion : @escaping (T) -> Void) {
        if RVApiManager.isConnectedToInternet {
            if isAnimating {
                KRProgressHUD.show()
            }
            let data: Data = image.jpegData(compressionQuality: 0.5)!//UIImageJPEGRepresentation(image, 0.5)!
            let name = Int(Date().timeIntervalSince1970)
            let uploadData = MultipartObject(data: data, name: imageName, fileName: "\(name).jpg", mimeType: "image/jpg")
            RVApiManager.shared.upLoadApi(apiUrl, uploadObjects: [uploadData], parameter: parameters,Vc: Vc) { (result, error) in
                if isAnimating {
                    KRProgressHUD.dismiss()
                }
                guard error == nil else {
                    Vc.showAlert(message: (error?.localizedDescription)!, strtitle: "Error")
                    return }
                guard let data = result else {return}
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data as! Data)
                    completion(obj)
                }
                catch let jsonError {
                    print("failed to dowload data", jsonError)
                    Vc.showAlert(message: "Error", strtitle: jsonError.localizedDescription)
                }
            }
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }
    
    class func putApiWithImage<T : Decodable >(_ apiUrl: String = "", image: UIImage, imageName: String,Vc: UIViewController, parameters : [String: Any] = [:],isAnimating : Bool = true, completion : @escaping (T) -> Void) {
        if RVApiManager.isConnectedToInternet {
            if isAnimating {
                KRProgressHUD.show()
            }
            let data: Data = image.jpegData(compressionQuality: 0.5)!//UIImageJPEGRepresentation(image, 0.5)!
            let name = Int(Date().timeIntervalSince1970)
            let uploadData = MultipartObject(data: data, name: imageName, fileName: "\(name).jpg", mimeType: "image/jpg")
            RVApiManager.shared.upLoadApi(apiUrl, uploadObjects: [uploadData],type: .put, parameter: parameters, Vc: Vc) { (result, error) in
                if isAnimating {
                    KRProgressHUD.dismiss()
                }
                guard error == nil else {
                    Vc.showAlert(message: (error?.localizedDescription)!, strtitle: "Error")
                    return }
                guard let data = result else {return}
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data as! Data)
                    completion(obj)
                }
                catch let jsonError {
                    print("failed to dowload data", jsonError)
                    Vc.showAlert(message: "Error", strtitle: jsonError.localizedDescription)
                }
            }
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }

    
    func postGifImage <T : Decodable>(_ apiUrl: String = "", GifData: Data, imageName: String,Vc: UIViewController, parameters : [String: Any] = [:], completion : @escaping(T)->Void) {
        if RVApiManager.isConnectedToInternet {
            KRProgressHUD.show()
            let name = Int(Date().timeIntervalSince1970)
            let uploadData = MultipartObject(data: GifData, name: imageName, fileName: "\(name).gif", mimeType: "image/gif")
            RVApiManager.shared.upLoadApi(apiUrl, uploadObjects: [uploadData], parameter: parameters, Vc: Vc) { (result, error) in
                KRProgressHUD.dismiss()
                guard error == nil else {
                    Vc.showAlert(message: (error?.localizedDescription)!, strtitle: "Error")
                    return }
                guard let data = result else {return}
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data as! Data)
                    completion(obj)
                }
                catch let jsonError {
                    print("failed to dowload data", jsonError)
                    Vc.showAlert(message: "Error", strtitle: jsonError as! String)
                }
            }
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }
    
    class func postApiWithVideo<T : Decodable > (_ apiUrl : String,imageData : UIImage? ,videoData : Data?, Vc : UIViewController, parameters : [String : Any], completion : @escaping (T) -> Void) {
        if RVApiManager.isConnectedToInternet {
            KRProgressHUD.show()
            let name = Int(Date().timeIntervalSince1970)
            var uploadData:[MultipartObject] = []
            if let imageData = imageData!.jpegData(compressionQuality: 0.8), let data1 = videoData
            {
                uploadData = [
                    MultipartObject(data: imageData, name: "video_thumbnail", fileName: "thumbnail_image_\(name).png", mimeType: "mp4"),MultipartObject(data: data1, name: "my_video_upload", fileName: "video_\(name).mov", mimeType: "mov")
                ]
            }
            RVApiManager.shared.upLoadApi(apiUrl, uploadObjects: uploadData, parameter: parameters, Vc: Vc) { (result, error) in
                KRProgressHUD.dismiss()
                guard error == nil else {
                    Vc.showAlert(message: (error?.localizedDescription)!, strtitle: "Error")
                    return }
                guard let data = result else {return}
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data as! Data)
                    completion(obj)
                }
                catch let jsonError {
                    print("failed to dowload data", jsonError)
                    Vc.showAlert(message: "Error", strtitle: jsonError as! String)
                }
            }
        }
        else {
            Vc.showAlert(message: ("No Internet Connected"), strtitle: "Error")
        }
    }
}

// MARK:-   MultiPartObject Class
class MultipartObject : NSObject {
    var dataObj : Data! = nil
    var strName : String = ""
    var strFileName : String = ""
    var strMimeType : String = ""
    
    init(data: Data!, name: String!, fileName: String!, mimeType: String! ) {
        super.init()
        dataObj = data
        strName = name
        strFileName = fileName
        strMimeType = mimeType
    }
}


