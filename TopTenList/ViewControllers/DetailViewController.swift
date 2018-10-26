//
//  DetailViewController.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 20/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var rating: UILabel!
    
    var photoURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        navigationItem.title = "Description"
        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = tmdb {
            
            // Check for type Movie
            if let movie = tmdb as? Movie {
                if let label = header {
                    guard movie.title != "" else{
                        label.text = "No Title"
                        return
                    }
                    label.text = movie.title ?? "No Title"
                }
            }
                
            // Check for type TvShow
            else if let tvShow = tmdb as? TvShow {
                if let label = header {
                    guard tvShow.name != "" else{
                        label.text = "No Title"
                        return
                    }
                    label.text = tvShow.name ?? "No Title"
                }
            }
            
            // Set description label
            if let label = desc {
                guard detail.overview != "" else {
                    label.text = "No description"
                    return
                }
                label.text = detail.overview ?? "No description"
            }
            
            // Set image label
            if let label = image {
                var urlString = "default_image.png"
                
                if detail.poster_path != nil {
                    urlString = Config.basePhotoUrl + detail.poster_path!
                    let url = URL(string: urlString)!
                    label.kf.setImage(with: url)
                } else {
                    label.image = UIImage(named: urlString)
                }
                
                label.layer.cornerRadius = 10
                label.clipsToBounds = true
            }
            
            // Set rating label
            if let label = rating {
                guard detail.vote_count! > 0 && detail.vote_count != nil else {
                    label.text = "Rating: No votes given!"
                    return
                }
                let formatted = String(format: "%.1f", detail.vote_average!)
                label.text = "Rating: \(formatted)"
            }
        }
    }
    
    var tmdb: SharedPropertiesProtocol? {
        didSet {
            // Configure view
            configureView()
        }
    }

}
