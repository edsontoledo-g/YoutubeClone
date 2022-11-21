//
//  VideoCell.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/11/22.
//

import UIKit
import SDWebImage

class VideoCell: UITableViewCell {
    @IBOutlet var videoImage: UIImageView!
    @IBOutlet var videoTitle: UILabel!
    @IBOutlet var channelName: UILabel!
    @IBOutlet var videoInfoLabel: UILabel!
    @IBOutlet var moreButton: UIButton!
    
    var didPressMoreButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
    }
    
    func setUpView() {
        moreButton.setImage(UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = UIColor(named: "grayColor")
        videoImage.layer.cornerRadius = 4.0
    }
    
    func configure(with item: Any) {
        if let video = item as? VideoResponse.Item {
            videoTitle.text = video.snippet?.title
            channelName.text = video.snippet?.channelTitle
            videoInfoLabel.text = "\(video.statistics?.viewCount ?? "") · \(video.snippet?.publishedAt ?? "")"
            
            if let videoImageUrl = video.snippet?.thumbnails.medium.url {
                videoImage.sd_setImage(with: URL(string: videoImageUrl))
            }
        } else if let playlistItem = item as? PlaylistItemResponse.Item {
            videoTitle.text = playlistItem.snippet?.title
            channelName.text = playlistItem.snippet?.channelTitle
            videoInfoLabel.text = ""
            
            if let videoImageUrl = playlistItem.snippet?.thumbnails.medium.url {
                videoImage.sd_setImage(with: URL(string: videoImageUrl))
            }
        }
        
    }
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        didPressMoreButton?()
    }
    
}
