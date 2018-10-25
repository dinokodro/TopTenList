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
            
            if let movie = tmdb as? Movie {
                if let label = header {
                    guard movie.title != "" else{
                        label.text = "No Title"
                        return
                    }
                    label.text = movie.title ?? "No Title"
                }
            }
                
            else if let tvShow = tmdb as? TvShow {
                if let label = header {
                    guard tvShow.name != "" else{
                        label.text = "No Title"
                        return
                    }
                    label.text = tvShow.name ?? "No Title"
                }
            }
            
            if let label = desc {
                guard detail.overview != "" else {
                    label.text = "No description"
                    return
                }
                label.text = detail.overview ?? "No description"
            }
            
            if let label = image {
                if detail.poster_path == nil || detail.poster_path == ""{
                    label.image = UIImage(named: "default_image.png")
                    return
                }
                else {
                    let urlString = Config.basePhotoUrl + detail.poster_path!
                    let url = URL(string: urlString)!
                    label.kf.setImage(with: url)
                }
                label.layer.cornerRadius = 10
                label.clipsToBounds = true
            }
            
            if let label = rating {
                guard detail.vote_count! == 0 else {
                    label.text = "Rating: No votes given!"
                    return
                }
                label.text = "Rating: \(detail.vote_average!)"
            }
        }
    }
    
    var tmdb: SharedPropertiesProtocol? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}
