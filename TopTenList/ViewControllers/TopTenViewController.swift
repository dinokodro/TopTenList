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
import PromiseKit

class TopTenViewController: UIViewController {
    
    var movies = [Movie]()
    var tvShows = [TvShow]()
    var filteredMovies = [Movie]()
    var filteredTvShows = [TvShow]()
    var searchText: String?
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        customizeNavBar()
        
        ApiManager.shared.fetchTopRatedMovies().done({
            movies in
                self.movies = movies
                self.tableView.reloadData()
            }).catch { error in
                            //Handle error or give feedback to the user
            print(error.localizedDescription)
            }

        ApiManager.shared.fetchTopRatedTvShows().done({
            tvShows in
                self.tvShows = tvShows
                self.tableView.reloadData()
        }).catch { error in
                //Handle error or give feedback to the user
                print(error.localizedDescription)
        }
        
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

        // Customize search controller
        searchController.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "Search Tv Shows"
        searchController.searchBar.delegate = self

        // Attach search controller to navbar
        navigationItem.searchController = searchController
        navigationItem.title = "TMDB top 10 ratings"

    }

    func setSearchBarPlaceholder() {
        searchController.searchBar.text = ""
        addScopeButtomBorder(withColor: UIColor.white)
        if segmentControl.selectedSegmentIndex == 0 {
            searchController.searchBar.placeholder = "Search Tv Shows"
        }

        else {
            searchController.searchBar.placeholder = "Search Movies"
        }
    }

    // Reload tableview on segmented control switch
    @IBAction func switchTableView(_ sender: Any) {
        tableView.reloadData()
        setSearchBarPlaceholder()
        clearSearchFilters()
    }

    func addScopeButtomBorder(withColor: UIColor) {
        let scopeBarHeight = segmentControl.frame.height
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -1000, y: scopeBarHeight + 8, width: 5000, height: 0.5)
        bottomLine.backgroundColor = withColor.cgColor
        segmentControl.layer.addSublayer(bottomLine)
    }

    func clearSearchFilters(){
        filteredTvShows = []
        filteredMovies = []
        tableView.reloadData()
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
                    guard !filteredTvShows.isEmpty else {
                        controller.tvShow = tvShows[indexPath.row]
                        return
                    }
                    controller.tvShow = filteredTvShows[indexPath.row]
                    
                case 1:
                    guard !filteredMovies.isEmpty else {
                        controller.movie = movies[indexPath.row]
                        return
                    }
                    controller.movie = filteredMovies[indexPath.row]
                    
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
    
    // Add bottom border to scope if user is scrolling down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var lastVelocityYSign = 0
        let currentVelocityY = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        if currentVelocityYSign != lastVelocityYSign &&
            currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        if lastVelocityYSign < 0 {
            addScopeButtomBorder(withColor: UIColor.lightGray)

        }
        else if lastVelocityYSign > 0 {
            addScopeButtomBorder(withColor: UIColor.white)
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
         addScopeButtomBorder(withColor: UIColor.white)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch segmentControl.selectedSegmentIndex {
        case 0:
            guard !filteredTvShows.isEmpty else {
                return tvShows.count
            }
            return filteredTvShows.count

        case 1:
            guard !filteredMovies.isEmpty else {
                return movies.count
            }
            return filteredMovies.count

        default:
            break
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            guard !filteredTvShows.isEmpty else {
                let tvShow = tvShows[indexPath.row]
                return cell.createTvShowCell(cell: cell, tvShow: tvShow, index: indexPath.row)
            }

            let filteredTvShow = filteredTvShows[indexPath.row]
            return cell.createTvShowCell(cell: cell, tvShow: filteredTvShow, index: indexPath.row)
            
        case 1:
            guard !filteredMovies.isEmpty else {
                let movie = movies[indexPath.row]
                return cell.createMovieCell(cell: cell, movie: movie, index: indexPath.row)
            }
            
            let filteredMovie = filteredMovies[indexPath.row]
            return cell.createMovieCell(cell: cell, movie: filteredMovie, index: indexPath.row)
            
        default:
            return cell
        }
    }
}

extension TopTenViewController: UISearchControllerDelegate, UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.searchText = searchText
        let formattedSearchText = searchText.replacingOccurrences(of: " ", with: "%20")
        guard searchText.count > 2 else {
            clearSearchFilters()
            return
        }
        
        switch segmentControl.selectedSegmentIndex{
        case 0:
            ApiManager.shared.searchTopRatedTvShows(query: formattedSearchText).done({ filteredTvShows in
                self.clearSearchFilters()
                self.filteredTvShows = filteredTvShows
                self.tableView.reloadData()
            }).catch { error in
                self.clearSearchFilters()
                print(error.localizedDescription)
            }
            
        case 1:
            ApiManager.shared.searchMovies(query: formattedSearchText).done( { filteredMovies in
                self.clearSearchFilters()
                self.filteredMovies = filteredMovies
                self.tableView.reloadData()
            }).catch { error in
                self.clearSearchFilters()
                print(error.localizedDescription)
            }

        default:
            break
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.searchText != nil {
            searchBar.text = self.searchText
        }
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.text = self.searchText
    }
}

