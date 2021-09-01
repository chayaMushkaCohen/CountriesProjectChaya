//
//  Country.swift
//  MatrixCountriesProjectCohenChayaMushka
//
//  Created by hyperactive on 18/06/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import Foundation


class Country {
    let name: String
    let nativeName: String
    let area: Double
    var bordersCountries: [Country]
    let bordersStrings: [String]
    let alphaCode: String
    
    init(name: String, nativeName: String, area: Double, bordersCountries: [Country], bordersStrings: [String], alphaCode: String) {
        self.name = name
        self.nativeName = nativeName
        self.area = area
        self.bordersCountries = bordersCountries
        self.bordersStrings = bordersStrings
        self.alphaCode = alphaCode
    }
    
    init(name: String, nativeName: String, area: Double, bordersStrings: [String], alphaCode: String) {
        self.name = name
        self.nativeName = nativeName
        self.area = area
        self.bordersCountries = []
        self.bordersStrings = bordersStrings
        self.alphaCode = alphaCode
    }
}
