//
//  PlaylistCell.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 07/11/22.
//

import UIKit
import SDWebImage

class PlaylistCell: UITableViewCell {

    @IBOutlet var videoImage: UIImageView!
    @IBOutlet var videoTitle: UILabel!
    @IBOutlet var videoCount: UILabel!
    @IBOutlet var videoCountOverlay: UILabel!
    @IBOutlet var moreButton: UIButton!
    
    var didPressMoreButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
    }
    
    func setUpView() {
        moreButton.setImage(UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = UIColor(named: "grayColor")
    }
    
    func configure(with playlist: PlaylistResponse.Item) {
        videoTitle.text = playlist.snippet?.title
        videoCount.text = "\(playlist.contentDetails?.itemCount ?? 0) videos"
        videoCountOverlay.text = "\(playlist.contentDetails?.itemCount ?? 0)"
        
        if let playlistImageUrl = playlist.snippet?.thumbnails.high.url {
            videoImage.sd_setImage(with: URL(string: playlistImageUrl))
        }
    }
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        didPressMoreButton?()
    }
}
