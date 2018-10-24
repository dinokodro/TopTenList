//
//  TopRatedTvShowsResult.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 24/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation

struct TopRatedTvShowsResult: Decodable {
    
    var page: Int
    
    var total_results: Int
    
    var total_pages: Int
    
    var results: [TvShow]
    
}
