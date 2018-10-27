//
//  CustomTableViewCell.swift
//  TopTenList
//
//  Created by Sabahudin Kodro on 20/10/2018.
//  Copyright © 2018 Kodro. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var ranking: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var arrow: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Create movie cell via createCell() function.
    func createMovieCell(cell: CustomTableViewCell, movie: Movie, index: Int) -> CustomTableViewCell{
        var cellToReturn: CustomTableViewCell
        cellToReturn = createCell(cell: cell, tmdb: movie, index: index)
        cellToReturn.title.text = movie.title!
        return cellToReturn
    }
    
    // Create tv show cell via createCell() function.
    func createTvShowCell(cell: CustomTableViewCell, tvShow: TvShow , index: Int) -> CustomTableViewCell{
        var cellToReturn: CustomTableViewCell
        cellToReturn = createCell(cell: cell, tmdb: tvShow, index: index)
        cellToReturn.title.text = tvShow.name!
        return cellToReturn
    }
    
    // Create cells based on the values provided by the SharedPropertiesProtocol
    func createCell(cell: CustomTableViewCell, tmdb: SharedPropertiesProtocol, index: Int) -> CustomTableViewCell{
        var urlString = "default_image.png"
        
        // Check for poster path. If not nil, assign url. If nil, assign default image.
        if tmdb.poster_path != nil {
            urlString = Config.basePhotoUrl + tmdb.poster_path!
            let url = URL(string: urlString)!
            cell.photo.kf.setImage(with: url)
        } else { cell.photo.image = UIImage(named: urlString) }
        
        // Make image label rounded in the corners
        cell.photo.layer.cornerRadius = 10
        cell.photo.clipsToBounds = true
        
        // Set ranking label to value of the index in the array
        cell.ranking.text = "\(index + 1)"
        
        // Check if the object has any votes casted regarding rating. If it has, assign rating. If not assign empty string.
        if tmdb.vote_count! > 0{
            let formatted = String(format: "%.1f", tmdb.vote_average!)
            cell.rating.text = formatted
        }
        else { cell.rating.text = "" }
        
        // Check if description is available. If not, assign default value.
        if tmdb.overview! == "" {
            cell.desc.text = "No Description"
        }
        else { cell.desc.text = tmdb.overview }
        
        // Return the created cell
        return cell
    }
}
