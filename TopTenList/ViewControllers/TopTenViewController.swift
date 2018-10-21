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

class TopTenViewController: UIViewController {
    
    var detailViewController: DetailViewController? = nil
    var movies = [Movie]()
    var tvShows = [TvShow]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        createNavBar()
        getTopRatedMovies()
        getTopRatedTvShows()
    }
    
    func createNavBar () {
        
        //Set Large Titles
        navigationController?.navigationBar.prefersLargeTitles = true

        // Create Search controller
        let searchController = UISearchController(searchResultsController: nil)
        let searchBar = searchController.searchBar
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        
        // Attach search controller to navbar
        navigationItem.searchController = searchController
        navigationItem.title = "Top Ten List"
    }
    
    // Reload tableview on segmented control switch
    @IBAction func switchTableView(_ sender: Any) {
        tableView.reloadData()
    }
    
    // Get top rated movies from TMDB, through Alamofire and swiftyJSON
    func getTopRatedMovies () {
        Alamofire.request("https://api.themoviedb.org/3/movie/top_rated?api_key=4aa0aa668b1d20ef02867315419d5880&language=en-US").responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posterRoot = Config.base_URL + Config.listPhotoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    let newMovie = Movie(imageURL: posterRoot + (SubJSON["poster_path"].rawValue as! String),
                                         title: SubJSON["title"].rawValue as! String,
                                         description: SubJSON["overview"].rawValue as! String)

                    self.movies.append(newMovie)
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Get top rated Tv Shows from TMDB, through Alamofire and swiftyJSON
    func getTopRatedTvShows () {
        Alamofire.request("https://api.themoviedb.org/3/tv/top_rated?api_key=4aa0aa668b1d20ef02867315419d5880&language=en-US&page=1").responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posterRoot = Config.base_URL + Config.listPhotoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    let newTvShow = TvShow(imageURL: posterRoot + (SubJSON["poster_path"].rawValue as! String),
                                        title: SubJSON["name"].rawValue as! String,
                                        description: SubJSON["overview"].rawValue as! String)
                    
                    self.tvShows.append(newTvShow)
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

// Extension of TopTenViewController dealing with table-related tasks
extension TopTenViewController: UITableViewDataSource, UITableViewDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
//                switch segmentControl.selectedSegmentIndex {
//                case 0:
////                    let movie = movies[indexPath.row]
////                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
////                        controller.detailItem = movie
////                        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                //                controller.navigationItem.leftItemsSupplementBackButton = true
//                case 1:
////                    let tvShow = movies[indexPath.row]
////                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
////                        controller.detailItem = object
////                        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                    //  controller.navigationItem.leftItemsSupplementBackButton = true
//                default:
//                    break
//                }
               
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
            
        case 0:
            return movies.count
            
        case 1:
            return tvShows.count
            
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        switch segmentControl.selectedSegmentIndex {
            
        case 0:
            let movie = movies[indexPath.row]
            let url = URL(string: movie.imageURL)!
            cell.photo.kf.setImage(with: url)
            cell.ranking.text = "\(indexPath.row + 1)"
            cell.title.text = movie.title
            cell.desc.text = movie.description
            
        case 1:
            let tvShow = tvShows[indexPath.row]
            let url = URL(string: tvShow.imageURL)!
            cell.photo.kf.setImage(with: url)
            cell.ranking.text = "\(indexPath.row + 1)"
            cell.title.text = tvShow.title
            cell.desc.text = tvShow.description
            
        default:
            break
        }
        return cell
    }
    
}
