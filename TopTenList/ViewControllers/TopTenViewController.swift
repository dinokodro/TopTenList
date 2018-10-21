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
    
    var movies = [TMDB]()
    var tvShows = [TMDB]()

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
        let searchBar = searchController.searchBar
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        
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
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posterRoot = Config.base_URL + Config.listPhotoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    let newMovie = TMDB(imageURL: posterRoot + (SubJSON["poster_path"].rawValue as! String),
                                        rating: Double(truncating: SubJSON["vote_average"].rawValue as! NSNumber),
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
        Alamofire.request(Config.topRatedTvShowsURL).responseJSON {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let posterRoot = Config.base_URL + Config.listPhotoSize
                
                for(_, SubJSON):(String, JSON) in json["results"]{
                    let newTvShow = TMDB(imageURL: posterRoot + (SubJSON["poster_path"].rawValue as! String),
                                         rating: Double(truncating: SubJSON["vote_average"].rawValue as! NSNumber),
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

// Extension of TopTenViewController dealing with table related tasks
extension TopTenViewController: UITableViewDataSource, UITableViewDelegate{
    
    // Prepare for segue based on which button on segment index is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                var tmdb = movies[indexPath.row]
                
                switch segmentControl.selectedSegmentIndex {
                case 0:
                    tmdb = movies[indexPath.row]
                    
                case 1:
                    tmdb = tvShows[indexPath.row]
                    
                default:
                    break
                }
                
                let controller = segue.destination  as! DetailViewController
                controller.tmdb = tmdb
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
        
        var tmdb = movies[indexPath.row]
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            tmdb = movies[indexPath.row]
            
        case 1:
            tmdb = tvShows[indexPath.row]
        default:
            break
        }
        
        let url = URL(string: tmdb.imageURL)!

        cell.ranking.text = "\(indexPath.row + 1)"
        cell.photo.kf.setImage(with: url)
        cell.photo.layer.cornerRadius = 10
        cell.photo.clipsToBounds = true
        cell.rating.text = "\(tmdb.rating)"
        cell.title.text = tmdb.title
        cell.desc.text = tmdb.description
        
        return cell
    }
}
