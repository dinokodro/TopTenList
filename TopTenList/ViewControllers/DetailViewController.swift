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
        if let detail = movie {
            if let label = header {
                label.text = "\(detail.title ?? "No title")"
            }
            if let label = desc {
                label.text = detail.overview ?? "No description"
            }
            if let label = image {
                
                if detail.poster_path == nil {
                    let image = UIImage(named: "default_image.png")
                    label.image = image
                }
                else {
                    let url = URL(string: Config.basePhotoUrl + detail.poster_path!)!
                    label.kf.setImage(with: url)
                }
                
                label.layer.cornerRadius = 10
                label.clipsToBounds = true
                
            }
            if let label = rating {
                label.text = "Rating: \(detail.vote_average ?? 0)"
            }
        }
        
        else if let detail = tvShow {
            if let label = header {
                label.text = "\(detail.name ?? "No title")"
            }
            if let label = desc {
                label.text = detail.overview ?? "No description"
            }
            if let label = image {
                
                if detail.poster_path == nil {
                    let image = UIImage(named: "default_image.png")
                    label.image = image
                }
                else {
                    let url = URL(string: Config.basePhotoUrl + detail.poster_path!)!
                    label.kf.setImage(with: url)
                }
                
                label.layer.cornerRadius = 10
                label.clipsToBounds = true
                
            }
            if let label = rating {
                label.text = "Rating: \(detail.vote_average ?? 0)"
            }
        }
    }
    
    var movie: Movie? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    var tvShow: TvShow? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}
