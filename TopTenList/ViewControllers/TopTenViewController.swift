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
    }
    
    func createNavBar () {
        
        navigationController?.navigationBar.prefersLargeTitles = true

        let searchController = UISearchController(searchResultsController: nil)
        let searchBar = searchController.searchBar
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Top Ten App"
    }


    func getTopRatedMovies () {
        Alamofire.request("https://api.themoviedb.org/3/movie/top_rated?api_key=4aa0aa668b1d20ef02867315419d5880&language=en-US").responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    let newMovie = Movie(id: "1",
                                         posterPath: SubJSON["poster_path"].rawValue as! String,
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

}


extension TopTenViewController: UITableViewDataSource, UITableViewDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = movies[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        let movie = movies[indexPath.row]
        
        cell.ranking.text = "\(indexPath.row + 1)"
        cell.title.text = movie.title
        cell.desc.text = movie.description
        print(movie)
        return cell
    }
    
}
