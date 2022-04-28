//
//  CoinModel.swift
//  ByteCoin
//
//  Created by  Юлия Григорьева on 26.04.2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let currency: String
    let rate: Double

    var rateString: String {
        return String(format: "%.2f", rate)
}
}
