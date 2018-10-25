//
//  Movie.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 20/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation

struct TvShow: Decodable, SharedPropertiesProtocol {
    
    let name: String?
    
    let vote_average: Double?
    
    let overview: String?
    
    let poster_path: String?
    
    let vote_count: Int?
    
}
