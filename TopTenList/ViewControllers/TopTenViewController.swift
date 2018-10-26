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
    var apiManager = ApiManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        customizeNavBar()
        
        // Fetch top rated movies
        apiManager.fetchTopRatedMovies().done({
            movies in
                self.movies = movies
                self.tableView.reloadData()
            }).catch { error in
                print(error.localizedDescription)
            }

        // Fetch top rated tv shows
        apiManager.fetchTopRatedTvShows().done({
            tvShows in
                self.tvShows = tvShows
                self.tableView.reloadData()
        }).catch { error in
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

        //Set Large Titles of navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        // Remove shadow from navigation bar
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
    
    // Add buttom border to searchbar based on inputted color
    func addScopeButtomBorder(withColor: UIColor) {
        let scopeBarHeight = segmentControl.frame.height
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -1000, y: scopeBarHeight + 8, width: 5000, height: 0.5)
        bottomLine.backgroundColor = withColor.cgColor
        segmentControl.layer.addSublayer(bottomLine)
    }

    // Set searchbar placeholder based on which segment is cliked
    func setSearchBarPlaceholder() {
        switch segmentControl.selectedSegmentIndex{
        
        // Segment index 0: Top rated tv shows
        case 0:
            searchController.searchBar.placeholder = "Search Tv Shows"
        
        // Segment index 1: Top rated tv movie
        case 1:
            searchController.searchBar.placeholder = "Search Movies"
            
        default:
            break
        }
    }
    
    // Clear search filters and reload tableview
    func clearSearchFilters(){
        filteredTvShows = []
        filteredMovies = []
        tableView.reloadData()
    }
    
    // Scrolls tableview to first row
    func tableViewScrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    // Different actions performed if segmented index value changes
    @IBAction func segmentedControl_ValueChanged(_ sender: Any) {
        clearSearchFilters()
        tableViewScrollToFirstRow()
        tableView.reloadData()
        searchController.searchBar.text = ""
        self.searchText = ""
        setSearchBarPlaceholder()
        addScopeButtomBorder(withColor: UIColor.white)
    }
    
}

// Extension of TopTenViewController dealing with table related tasks
extension TopTenViewController: UITableViewDataSource, UITableViewDelegate{

    // Prepare for segue based on which button on segment index is clicked and if the user is in search mode or not
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            if let indexPath = tableView.indexPathForSelectedRow {

                let controller = segue.destination as! DetailViewController
                
                switch segmentControl.selectedSegmentIndex {
                    
                // Segment index 0: Top rated tv shows
                case 0:
                    guard !filteredTvShows.isEmpty else {
                        // Set property tmdb of controller to tvShows[indexPath.row] if filteredTvShows is empty
                        controller.tmdb = tvShows[indexPath.row]
                        return
                    }
                    // Set property tmdb of controller to filteredTvShows[indexPath.row] if this array is not empty
                    controller.tmdb = filteredTvShows[indexPath.row]
                    
                // Segment index 0: Top rated movies
                case 1:
                    guard !filteredMovies.isEmpty else {
                        // Set property tmdb of controller to movies[indexPath.row] if filteredMovies is empty
                        controller.tmdb = movies[indexPath.row]
                        return
                    }
                    // Set property tmdb of controller to filteredMovies[indexPath.row] if this array is not empty
                    controller.tmdb = filteredMovies[indexPath.row]
                    
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

    // Return height of cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    // Return number of sections in cells
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Return number of rows in tableview based on which segment index is clicked, and if the user is in search mode or not
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch segmentControl.selectedSegmentIndex {
            
        // Segment index is 0: Top rated tv shows
        case 0:
            guard !filteredTvShows.isEmpty else {
                // Return tvShows array length if filteredTvShows array is empty
                return tvShows.count
            }
            // Return filteredTvShows array length if this array is not empty
            return filteredTvShows.count
            
        // Segment index is 1: Top rated movies
        case 1:
            guard !filteredMovies.isEmpty else {
                // Return movies array length if filteredMovies array is empty
                return movies.count
            }
            
            // Return filteredMovies array length if this array is not empty
            return filteredMovies.count
            
        default:
            break
        }
        
        return 0
    }

    // Create cells in tableview based on which segment index is clicked, and if the user is in search mode or not
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        switch segmentControl.selectedSegmentIndex {
            
        // Segment index is 0: Top rated tv shows
        case 0:
            guard !filteredTvShows.isEmpty else {
                // created cell based on tvShows array if filteredTvShows array is empty
                let tvShow = tvShows[indexPath.row]
                return cell.createTvShowCell(cell: cell, tvShow: tvShow, index: indexPath.row)
            }
            // created cell based on filteredTvShows array, if this array is not empty
            let filteredTvShow = filteredTvShows[indexPath.row]
            return cell.createTvShowCell(cell: cell, tvShow: filteredTvShow, index: indexPath.row)
            
        // Segment index 1: Top rated movies
        case 1:
            guard !filteredMovies.isEmpty else {
                // created cell based on movies array if filteredMovies array is empty
                let movie = movies[indexPath.row]
                return cell.createMovieCell(cell: cell, movie: movie, index: indexPath.row)
            }
            // created cell based on filteredMovies array, if this array is not empty
            let filteredMovie = filteredMovies[indexPath.row]
            return cell.createMovieCell(cell: cell, movie: filteredMovie, index: indexPath.row)
            
        default:
            return cell
        }
    }
    
    // Add ligth grey border to scope if user is scrolling down, add white if user is scrolling up
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Find direction of scrolling
        var lastVelocityYSign = 0
        let currentVelocityY = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
        let currentVelocityYSign = Int(currentVelocityY).signum()
        
        if currentVelocityYSign != lastVelocityYSign && currentVelocityYSign != 0 {
            lastVelocityYSign = currentVelocityYSign
        }
        
        // If scroll direction is downwards, addScopeButtomBorder(withColor: UIColor.lightGray)
        if lastVelocityYSign < 0 { addScopeButtomBorder(withColor: UIColor.lightGray) }
            
        // If scroll direction is upwards, addScopeButtomBorder(withColor: UIColor.white)
        else if lastVelocityYSign > 0 { addScopeButtomBorder(withColor: UIColor.white) }
    }
    
    // Add white buttom scope border if scroll view did scroll to top
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        addScopeButtomBorder(withColor: UIColor.white)
    }
}

// Extension of TopTenViewController dealing search related tasks
extension TopTenViewController: UISearchControllerDelegate, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Perform search if the user has typed atleast 3 letters.
        self.searchText = searchText
        
        // Format spaces in searchtext to match how spaces are required by API
        let formattedSearchText = searchText.replacingOccurrences(of: " ", with: "%20")
        guard searchText.count > 2 else {
            clearSearchFilters()
            return
        }
        
        // Search tv shows or movies, based on which segment index is clicked
        switch segmentControl.selectedSegmentIndex{
        case 0:
            // Segment index 0: Search for top rated tv shows
            apiManager.searchTopRatedTvShows(query: formattedSearchText).done({ filteredTvShows in
                self.clearSearchFilters()
                self.filteredTvShows = filteredTvShows
                self.tableView.reloadData()
            // Catch error if fail
            }).catch { error in
                self.clearSearchFilters()
                print(error.localizedDescription)
            }
        case 1:
            // Segment index 1: Search for top rated movies
            apiManager.searchMovies(query: formattedSearchText).done( { filteredMovies in
                self.clearSearchFilters()
                self.filteredMovies = filteredMovies
                self.tableView.reloadData()
            // Catch error if fail
            }).catch { error in
                self.clearSearchFilters()
                print(error.localizedDescription)
            }
            
        default:
            break
        }
    }
    
    // Add search text to searchbar after search bar editing is done
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.text = self.searchText
    }
    
    // Add search text to searchbar after dismissal of the searchcontroller. This is when a person presses the search button
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = self.searchText
    }
    
    /*
    The tranistion of the dismissal of the search controller is not so smooth.
    Adding the searchbar text in willDismissSearchController does not change the
    text in the searchbar during dismissal. This leads to a bad UI, where the
    searchtext dissapears during the dismisall of the searchcontroller,
    but then reapears after the dismisall is done.
    The code below does not have any effect.
    */
    func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = self.searchText
    }
}

