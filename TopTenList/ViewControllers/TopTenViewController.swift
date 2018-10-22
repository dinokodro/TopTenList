//
//  TopTenViewController.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 20/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import Promises

class TopTenViewController: UIViewController {
    
    var movies = [TMDB]()
    var tvShows = [TMDB]()
    var filteredMovies = [TMDB]()
    var filteredTvShows = [TMDB]()
    let arraySize = 10
    var searchText: String?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        customizeNavBar()
        getTopRatedMovies()
        getTopRatedTvShows()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Remove selection on tableview cell when navigating back from detailview
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    // Customize navbvar to prefer large titles and attach searchResultsController
    func customizeNavBar () {
        
        //Set Large Titles
        navigationController?.navigationBar.prefersLargeTitles = true
        // Remove shadow
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        // Create Search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsScopeBar = true
        
        
        // Attach search controller to navbar
        navigationItem.searchController = searchController
        navigationItem.title = "TMDB top 10 ratings"
    }
    
    // Reload tableview on segmented control switch
    @IBAction func switchTableView(_ sender: Any) {
        tableView.reloadData()
    }
    
    // Get top rated movies from TMDB, through Alamofire and swiftyJSON
    func getTopRatedMovies () {
        Alamofire.request(Config.topRatedMoviesURL).responseJSON {
            response in
            
            var count = 0
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posterRoot = Config.base_URL + Config.photoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    let newMovie = TMDB(imageURL: posterRoot + (SubJSON["poster_path"].rawValue as! String),
                                        rating: Double(truncating: SubJSON["vote_average"].rawValue as! NSNumber),
                                        title: SubJSON["title"].rawValue as! String,
                                        description: SubJSON["overview"].rawValue as! String)

                    if count < self.arraySize {
                        self.movies.append(newMovie)
                    }
                    else { break }
                    count += 1
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Get top rated Tv Shows from TMDB, through Alamofire and swiftyJSON
    func getTopRatedTvShows (){
        Alamofire.request(Config.topRatedTvShowsURL).responseJSON {
            response in
            var count = 0
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posterRoot = Config.base_URL + Config.photoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    let newTvShow = TMDB(imageURL: posterRoot + (SubJSON["poster_path"].rawValue as! String),
                                         rating: Double(truncating: SubJSON["vote_average"].rawValue as! NSNumber),
                                         title: SubJSON["name"].rawValue as! String,
                                         description: SubJSON["overview"].rawValue as! String)
                    
                    if count < self.arraySize {
                        self.tvShows.append(newTvShow)
                    }
                    else { break }
                    count += 1
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchMovies (query: String){
        Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=4aa0aa668b1d20ef02867315419d5880&language=en-US&query=\(query)&page=1&include_adult=false").responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posterRoot = Config.base_URL + Config.photoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    
                    let newMovie = TMDB(imageURL: posterRoot + "\(SubJSON["poster_path"])",
                                         rating: Double(truncating: SubJSON["vote_average"].rawValue as! NSNumber),
                                         title: SubJSON["title"].rawValue as! String,
                                         description: SubJSON["overview"].rawValue as! String)
                    self.filteredMovies.append(newMovie)
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchTvShows (query: String){
        Alamofire.request("https://api.themoviedb.org/3/search/tv?api_key=4aa0aa668b1d20ef02867315419d5880&language=en-US&query=\(query)&page=1&include_adult=false").responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print(json)
                let posterRoot = Config.base_URL + Config.photoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    
                    let newTvShow = TMDB(imageURL: posterRoot + "\(SubJSON["poster_path"])",
                        rating: Double(truncating: SubJSON["vote_average"].rawValue as! NSNumber),
                        title: SubJSON["name"].rawValue as! String,
                        description: SubJSON["overview"].rawValue as! String)
                    self.filteredTvShows.append(newTvShow)
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func clearSearchFilters(){
        filteredTvShows = []
        filteredMovies = []
        tableView.reloadData()
    }
    
    func searchTextCountIsGreaterThanTwo (searchText: String) -> Bool{
        if searchText.count > 2 {
            return true
        }
        else { return false }
    }
    
    func segmentedControlIndexIsZero() -> Bool {
        if segmentControl.selectedSegmentIndex == 0 {
            return true
        }
        else { return false }
    }
    
    func createCell(cell: CustomTableViewCell, tmdb: TMDB, index: Int, url: URL) -> CustomTableViewCell{
        cell.ranking.text = "\(index + 1)"
        cell.photo.kf.setImage(with: url)
        cell.photo.layer.cornerRadius = 10
        cell.photo.clipsToBounds = true
        cell.rating.text = "\(tmdb.rating)"
        cell.title.text = tmdb.title
        cell.desc.text = tmdb.description
        return cell
    }
}

// Extension of TopTenViewController dealing with table related tasks
extension TopTenViewController: UITableViewDataSource, UITableViewDelegate{
    
    // Prepare for segue based on which button on segment index is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let controller = segue.destination  as! DetailViewController
                
                switch segmentControl.selectedSegmentIndex {
                    
                case 0:
                    guard !filteredMovies.isEmpty else {
                        controller.tmdb = movies[indexPath.row]
                        return
                    }
                    controller.tmdb = filteredMovies[indexPath.row]
                    
                case 1:
                    guard !filteredTvShows.isEmpty else {
                        controller.tmdb = tvShows[indexPath.row]
                        return
                    }
                    controller.tmdb = filteredTvShows[indexPath.row]
                    
                default:
                    break
                }
            }
        }
    }
    
    
    
    // Perform segue to detailview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            guard !filteredMovies.isEmpty else {
                return movies.count
            }
            return filteredMovies.count
            
        case 1:
            guard !filteredTvShows.isEmpty else {
                return tvShows.count
            }
            return filteredTvShows.count
            
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            guard !filteredMovies.isEmpty else {
                let movie = movies[indexPath.row]
                let url = URL(string: movie.imageURL)!
                return createCell(cell: cell, tmdb: movie, index: indexPath.row, url: url)
            }
            
            let filteredMovie = filteredMovies[indexPath.row]
            let url = URL(string: filteredMovie.imageURL)!
            return createCell(cell: cell, tmdb: filteredMovie, index: indexPath.row, url: url)
            
        case 1:
            guard !filteredTvShows.isEmpty else {
                let tvShow = tvShows[indexPath.row]
                let url = URL(string: tvShow.imageURL)!
                return createCell(cell: cell, tmdb: tvShow, index: indexPath.row, url: url)
            }
            
            let filteredTvShow = filteredTvShows[indexPath.row]
            let url = URL(string: filteredTvShow.imageURL)!
            return createCell(cell: cell, tmdb: filteredTvShow, index: indexPath.row, url: url)
            
        default:
            return cell
        }
    }
}

extension TopTenViewController: UISearchControllerDelegate, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        guard searchTextCountIsGreaterThanTwo(searchText: searchText) else {
            clearSearchFilters()
            return
        }

        guard segmentedControlIndexIsZero() else {
            self.searchTvShows(query: searchText)
            tableView.reloadData()
            return
        }

        clearSearchFilters()
        self.searchMovies(query: searchText)
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.searchText != nil {
            searchBar.text = self.searchText
        }
    }
}
