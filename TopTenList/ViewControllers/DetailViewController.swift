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
    
    @IBOutlet weak var desc: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = tmdb {
            if let label = header {
                label.text = "\(detail.title)"
            }
            if let label = desc {
                label.text = detail.description
            }
            if let label = image {
                let url = URL(string: detail.imageURL)!
                label.kf.setImage(with: url)
                label.layer.cornerRadius = 10
                label.clipsToBounds = true
            }
        }
    }
    
    var tmdb: TMDB? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}
