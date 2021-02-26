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
    var amount: Double?
    var created: Date?
    var currency: String?
    var desc: String?
    
    enum CodingKeys: String, CodingKey {
        case amount
        case created
        case currency
        case desc
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let doubleAmount = try? values.decode(Double.self, forKey: .amount) {
            amount = doubleAmount
        } else if let stringAmount = try? values.decode(String.self, forKey: .amount) {
            amount = Double(stringAmount)
        } else {
            amount = nil
        }
        created = try? values.decode(Date.self, forKey: .created)
        currency = try? values.decode(String.self, forKey: .currency)
        desc = try? values.decode(String.self, forKey: .desc)
    }

    

}


func test() {
    let dataString = """
    [
        {"desc": "operation 1", "amount": 10.5, "currency": "USDT", "created": 1582148046},
        {"desc": "operation 8", "amount": "10", "currency": "XRP", "created": 1582189046}
    ]
    """

    guard let data = dataString.data(using: .utf8) else {
        print(#line, #function, "Can't encode data")
        return
    }

    guard let payments = try? JSONDecoder().decode([PaymentData].self, from: data) else {
        print(#line, #function, "Error decoding \(data)")
        return
    }

    for payment in payments {
        print(payment)
    }

    //test()
   
    
}





