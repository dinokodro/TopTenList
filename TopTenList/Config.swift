//
//  Config.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 20/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation

struct Config {
    static let API_KEY =  "4aa0aa668b1d20ef02867315419d5880"
    static let base_URL = "https://image.tmdb.org/t/p"
    static let photoSize = "/w300"
    static let onePage = "&page=1"
    static let topRatedMoviesURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=" + Config.API_KEY + Config.onePage
    static let topRatedTvShowsURL = "https://api.themoviedb.org/3/tv/top_rated?api_key=" + Config.API_KEY + Config.onePage
}

