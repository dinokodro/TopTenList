//
//  Movie.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 24/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation

// Movie struct adapting to the Decodable protocol and the SharedPropertiesProtocol
struct Movie: Decodable, SharedPropertiesProtocol {
    
    let title: String?
    
    let vote_average: Double?
    
    let overview: String?
    
    let poster_path: String?
    
    let vote_count: Int?
    
}
