//
//  ZenQuoteClient.swift
//  Memoriz
//
//  Created by Oladele Abimbola on 7/15/22.
//

import Foundation
import UIKit

class ZenQuoteClient{
    
    enum Endpoints{
        case randomQuote
        
        var stringValue:String{
            switch self {
            case .randomQuote:
                return "https://zenquotes.io/api/random"
            }
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    class func getRandomQuote(completion:@escaping (RandomQuoteResponse?, Error?)->Void){
        taskForGetREquest(url: Endpoints.randomQuote.url, response: RandomQuoteResponse.self) { response, error in
            if error != nil{
                completion(nil, error)
            }else{
                if let response = response{
                    for quote in response{
                        completion(quote, nil)
                    }
                }else{
                    completion(nil, error)
                }
            }
        }
    }
    
    class func taskForGetREquest<ResponseType: Decodable>(url:URL, response: ResponseType.Type, completion:@escaping([ResponseType?]?, Error?)->Void){
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let responseObject = try decoder.decode([ResponseType].self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    
//MARK: Another Method(Discard)
    //    class func getRandomQuote(completion:@escaping (RandomQuoteResponse?, Error?)->Void){
    //        taskForGetREquest(url: Endpoints.randomQuote.url, response: RandomQuoteResponse.self) { response, error in
    //            if let response = response{
    //                for quote in response{
    //                    completion(quote, nil)
    //                }
    //            }else{
    //                completion(nil, error)
    //            }
    //        }
    //    }
    
//    class func taskForGetREquest<ResponseType: Decodable>(url:URL, response: ResponseType.Type, completion:@escaping([ResponseType]?, Error?)->Void){
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//                return
//            }
//
//            let decoder = JSONDecoder()
//
//            do{
//                let responseObject = try decoder.decode([ResponseType].self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            }catch{
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//        task.resume()
//    }
    
}
