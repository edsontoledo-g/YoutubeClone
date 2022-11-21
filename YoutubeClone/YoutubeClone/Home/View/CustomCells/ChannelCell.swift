//
//  ChannelCell.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/11/22.
//

import UIKit
import SDWebImage

class ChannelCell: UITableViewCell {
    @IBOutlet var channelBanner: UIImageView!
    @IBOutlet var channelImage: UIImageView!
    @IBOutlet var channelTitle: UILabel!
    @IBOutlet var subscribeLabel: UILabel!
    @IBOutlet var subscibersCountLabel: UILabel!
    @IBOutlet var bellImage: UIImageView!
    @IBOutlet var channelInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
    }
    
    func setUpView() {
        bellImage.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
        bellImage.tintColor = UIColor(named: "whiteColor")
        
        channelImage.layer.cornerRadius = 30.0
    }
    
    func configure(with channel: ChannelResponse.Item) {
        channelTitle.text = channel.snippet?.title
        subscibersCountLabel.text = "\(channel.statistics?.subscriberCount ?? "0") subscribers".uppercased()
        channelInfoLabel.text = channel.snippet?.description
        
        if let channelBannerUrl = channel.brandingSettings?.image.bannerExternalUrl {
            channelBanner.sd_setImage(with: URL(string: channelBannerUrl))
        }

        if let channelImageUrl = channel.snippet?.thumbnails.medium.url {
            channelImage.sd_setImage(with: URL(string: channelImageUrl))
        }
    }
}
