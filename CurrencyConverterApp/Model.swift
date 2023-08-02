//
//  Model.swift
//  CurrencyConverterApp
//
//  Created by 정해석 on 2023/08/02.
//

import Foundation

/** json interface 정의 */
struct CurrencyModel: Codable {
    let result: String?
    let provider: String?
    let baseCode: String?
    let rates: [String : Double]?
    let time: Int?
    
    enum CodingKeys: String, CodingKey {
        case result
        case provider
        case baseCode = "base_code"
        case rates
        case time = "time_last_update_unix"
    }
}
