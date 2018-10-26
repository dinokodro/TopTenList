//
//  ApiManager.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 24/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

class ApiManager {
    
    init(){}
    
    // Fetch top rated movies via the TMDB Api. Returns a promise
    func fetchTopRatedMovies() -> Promise<[Movie]>{
        return Promise { seal in
            Alamofire.request(Config.topRatedMoviesURL).responseJSON {
                response in
                switch response.result {
                // In case of success:
                case .success( _):
                    // Try decoding JSON of type TopRatedMovies result
                    do{
                        let topRatedMoviesResult = try JSONDecoder().decode(TopRatedMoviesResult.self, from: response.data!)
                        let movies = topRatedMoviesResult.results
                        let topTenMovies = Array(movies.prefix(10))
                        seal.fulfill(topTenMovies)
                    // Error in case of decoding fail
                    } catch {
                        seal.reject(error)
                    }
                // Error in case of API request fail
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
     // Fetch the movies the user searches for via the TMDB Api. Returns a promise
    func searchMovies (query: String) -> Promise<[Movie]>{
        return Promise { seal in
            Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=4aa0aa668b1d20ef02867315419d5880&language=en-US&query=\(query)&page=1&include_adult=false").responseJSON {
                response in
                    switch response.result {
                    // In case of success:
                    case .success( _):
                        // Try decoding JSON of type TopRatedMovies result
                        do{
                            let topRatedMoviesResult = try JSONDecoder().decode(TopRatedMoviesResult.self, from: response.data!)
                            let movies = topRatedMoviesResult.results
                            seal.fulfill(movies)
                        // Error in case of decoding fail
                        } catch {
                            seal.reject(error)
                        }
                    // Error in case of API request fail
                    case .failure(let error):
                        seal.reject(error)
                }
            }
        }
    }
    
    // Fetch top rated movies via the TMDB Api. Returns a promise
    func fetchTopRatedTvShows () -> Promise<[TvShow]>{
        return Promise { seal in
            Alamofire.request(Config.topRatedTvShowsURL).responseJSON {
                response in
                switch response.result {
                // In case of success:
                case .success( _):
                    // Try decoding JSON of type TopRatedTvShowsResult result
                    do{
                        let topRatedMoviesResult = try JSONDecoder().decode(TopRatedTvShowsResult.self, from: response.data!)
                        let tvShows = topRatedMoviesResult.results
                        let topTenTvShows = Array(tvShows.prefix(10))
                        seal.fulfill(topTenTvShows)
                    // Error in case of decoding fail
                    } catch {
                        seal.reject(error)
                    }
                // Error in case of API request fail
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
     // Fetch the tv shows the user searches for via the TMDB Api. Returns a promise
    func searchTopRatedTvShows (query: String) -> Promise<[TvShow]>{
        return Promise { seal in
            Alamofire.request("https://api.themoviedb.org/3/search/tv?api_key=4aa0aa668b1d20ef02867315419d5880&language=en-US&query=\(query)&page=1&include_adult=false").responseJSON {
                response in
                switch response.result {
                // In case of success:
                case .success( _):
                    // Try decoding JSON of type TopRatedTvShowsResult result
                    do{
                        let topRatedMoviesResult = try JSONDecoder().decode(TopRatedTvShowsResult.self, from: response.data!)
                        let tvShows = topRatedMoviesResult.results
                        seal.fulfill(tvShows)
                    // Error in case of decoding fail
                    } catch {
                        seal.reject(error)
                    }
                // Error in case of API request fail
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
