//
//  Structs.swift
//  Login Form App
//
//  Created by Нариман on 21.02.2021.
//

import Foundation



struct TestUnitResponse<T: Codable>: Codable {
    
   var success: String
    var response: T?
    var error: ErrorData?
    

}

struct LoginData: Codable {
    
    var token: String
    
}

struct ErrorData: Codable {
    
    var errorMsg: String
    var errorCode: Int
    
}

struct PaymentData: Codable {
    var desc: String?
    //var amount: Double?
    var currency: String?
    var created: Int?

}



