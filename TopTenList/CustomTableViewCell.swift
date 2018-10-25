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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func createMovieCell(cell: CustomTableViewCell, movie: Movie, index: Int) -> CustomTableViewCell{
        
        var cellToReturn: CustomTableViewCell
        cellToReturn = createCell(cell: cell, tmdb: movie, index: index)
        cellToReturn.title.text = movie.title!
        return cellToReturn
    }
    
    func createTvShowCell(cell: CustomTableViewCell, tvShow: TvShow , index: Int) -> CustomTableViewCell{
        
        var cellToReturn: CustomTableViewCell
        cellToReturn = createCell(cell: cell, tmdb: tvShow, index: index)
        cellToReturn.title.text = tvShow.name!
        return cellToReturn
    }
    
    func createCell(cell: CustomTableViewCell, tmdb: SharedPropertiesProtocol, index: Int) -> CustomTableViewCell{
        
        var urlString = "default_image.png"
        
        if tmdb.poster_path != nil {
            urlString = Config.basePhotoUrl + tmdb.poster_path!
            let url = URL(string: urlString)!
            cell.photo.kf.setImage(with: url)
        } else {
            cell.photo.image = UIImage(named: urlString)
        }
        
        cell.ranking.text = "\(index + 1)"
        cell.photo.layer.cornerRadius = 10
        cell.photo.clipsToBounds = true
        
        if tmdb.vote_count! > 0{
            cell.rating.text = "\(tmdb.vote_average!)"
        }
        else{
            cell.rating.text = ""
        }
        
        if tmdb.overview! == "" {
            cell.desc.text = "No Description"
        }
        else { cell.desc.text = tmdb.overview }
        
        return cell
    }
    

}
