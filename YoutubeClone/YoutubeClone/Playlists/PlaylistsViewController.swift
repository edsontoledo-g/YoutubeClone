//
//  PlaylistsViewController.swift
//  YoutubeClone
//
//  Created by Edson Dario Toledo Gonzalez on 03/11/22.
//

import UIKit

class PlaylistsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var presenter = PlaylistsPresenter()
    var playlistsList: [PlaylistResponse.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        presenter.delegate = self
        Task {
            await presenter.getPlaylists()
        }
    }
    
    func configureTableView() {
        let nibPlaylist = UINib(nibName: "\(PlaylistCell.self)", bundle: nil)
        tableView.register(nibPlaylist, forCellReuseIdentifier: "\(PlaylistCell.self)")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlist = playlistsList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistCell.self)", for: indexPath) as? PlaylistCell else {
            fatalError()
        }
        
        cell.configure(with: playlist)
        cell.didPressMoreButton = { [weak self] in
            self?.configureBottomSheet()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureBottomSheet() {
        let vc = BottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false)
    }
}

extension PlaylistsViewController: PlaylistsViewProtocol {
    func getPlaylists(playlists: [PlaylistResponse.Item]) {
        playlistsList = playlists
        tableView.reloadData()
    }
}
