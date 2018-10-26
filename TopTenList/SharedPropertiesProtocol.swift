//
//  BasicInfoProtocol.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 25/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation

// Shared properties protocol. Will be used by types that share these properties
protocol SharedPropertiesProtocol {
    
    var vote_average: Double? {get}
    
    var overview: String? {get}
    
    var poster_path: String? {get}
    
    var vote_count: Int? {get}
    
}
