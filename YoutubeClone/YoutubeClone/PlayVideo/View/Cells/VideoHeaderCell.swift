//
//  VideoHeaderCell.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 22/11/22.
//

import UIKit
import SDWebImage

class VideoHeaderCell: UITableViewCell {
    @IBOutlet var videoTitle: UILabel!
    @IBOutlet var videoStatistics: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var channelName: UILabel!
    @IBOutlet var subscribersCount: UILabel!
    @IBOutlet var bellIcon: UIImageView!
    @IBOutlet var buttonsIconListView: ButtonsIconList!
    @IBOutlet var commentTitle: UILabel!
    @IBOutlet var commentProfileImage: UIImageView!
    @IBOutlet var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureHorizontalButtons(_ video: VideoResponse.Item) {
        let options = [
            VideoButtonIcon(title: video.statistics?.likeCount ?? "-", icon: .like),
            VideoButtonIcon(title: "Dislike", icon: .dislike),
            VideoButtonIcon(title: "Share", icon: .share),
            VideoButtonIcon(title: "Download", icon: .download),
            VideoButtonIcon(title: "Save", icon: .save),
            VideoButtonIcon(title: "Airplay", icon: .airplay)
        ]
        
        buttonsIconListView.buttonIconsList = options
        buttonsIconListView.delegate = self
        buttonsIconListView.buildView()
    }
    
    func configureComment() {
        let randomInt = Int.random(in: 5000..<10000)
        commentTitle.text = "Comments \(randomInt)"
        comment.text = "Amazing!"
    }
    
    func channelDetails(_ video: VideoResponse.Item, _ channel: ChannelResponse.Item?) {
        channelName.text = channel?.snippet?.title
        
        bellIcon.image = UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate)
        bellIcon.tintColor = UIColor(named: "whiteColor")
        
        subscribersCount.text = "\(channel?.statistics?.subscriberCount ?? "") subscribers"
        
        if let imageUrl = channel?.snippet?.thumbnails.medium.url, let url = URL(string: imageUrl) {
            profileImage.sd_setImage(with: url)
            profileImage.layer.cornerRadius = 22.0
        }
    }

    func configure(video: VideoResponse.Item, channel: ChannelResponse.Item?) {
        configureHorizontalButtons(video)
        configureComment()
        
        videoTitle.text = video.snippet?.title
        
        let viewsCount = video.statistics?.viewCount ?? "0"
        let viewPlural = (Int(viewsCount)!) > 0 ? "views" : "view"
        var tags = ""
        if let tagsArray = video.snippet?.tags?.enumerated().filter({ $0.offset < 3 }).map({"#"+$0.element}) {
            tags = tagsArray.joined(separator: " ")
        }
        
        let published = video.snippet?.publishedAt ?? ""
        let wholeString = "\(viewsCount) \(viewPlural) · \(published) \(tags)"
        
        videoStatistics.text = wholeString
        
        channelDetails(video, channel)
    }
}


extension VideoHeaderCell: ButtonIconListProtocol {
    func didSelectOption(tag: Int) {
        
    }
}
