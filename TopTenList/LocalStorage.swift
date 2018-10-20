//
//  LocalStorage.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 20/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation

class LocalStorage {
    
    static let shared: LocalStorage = LocalStorage()
    var movies: [[String:Any]]
    var tvShows: [[String:Any]]
    
    init() {
        movies = [[String:Any]]()
        tvShows = [[String:Any]]()
    }
}

