//
//  DetailViewController.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 20/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import UIKit

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
        }
    }
    
    var tmdb: TMDB? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}
