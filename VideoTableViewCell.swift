//
//  VideoTableViewCell.swift
//  Week4
//
//  Created by 권현석 on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    static var identifier = "VideoTableViewCell"

    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        runtimeLabel.font = .systemFont(ofSize: 13)
        runtimeLabel.numberOfLines = 2
        thumbnail.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    

}
