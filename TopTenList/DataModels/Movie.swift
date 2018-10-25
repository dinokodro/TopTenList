//
//  Movie.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 24/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation

struct Movie: Decodable, SharedPropertiesProtocol {
    
    let title: String?
    
    let vote_average: Double?
    
    let overview: String?
    
    let poster_path: String?
    
}
