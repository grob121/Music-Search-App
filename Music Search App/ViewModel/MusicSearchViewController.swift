//
//  MusicSearchViewController.swift
//  Music Search App
//
//  Created by Allan Pagdanganan on 21/06/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class MusicSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var musicSearchBar: UISearchBar!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    
    let datafetcher = DataFetcher()
    var tracks = [Track]()
    var player: AVPlayer?
    var previousSelectedPath: IndexPath?
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action:
            #selector(MusicSearchViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        activityIndicator.isHidden = true
        
        musicTableView.isHidden = true
        musicTableView.rowHeight = UITableView.automaticDimension
        musicTableView.estimatedRowHeight = 120.0
        musicTableView.addSubview(refreshControl)
    }
    
    // MARK: - Table View Delegate and Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"musicTableViewCell") as! MusicTableViewCell
        
        let track = tracks[indexPath.row]
        cell.trackNameLbl.text = track.trackName
        cell.artistNameLbl.text = track.artistName
        cell.albumNameLbl.text = track.albumName
        cell.loadingIndicator.startAnimating()
        cell.playPauseBtn.imageView?.isHidden = true
        
        let task = URLSession.shared.dataTask(with: track.trackImageURL, completionHandler: { (data, response, error) in
            guard let data = data,
                let image = UIImage(data: data) else {
                    return
            }
            DispatchQueue.main.async {
                cell.loadingIndicator.stopAnimating()
                cell.trackImageView.image = image
                cell.playPauseBtn.imageView?.isHidden = false
            }
        })
        task.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicSearchBar.endEditing(true)
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! MusicTableViewCell
        
        if(currentCell.isSelected) {
            if(player !=  nil && previousSelectedPath == indexPath){
                if(player!.isPlaying){
                    player!.pause()
                    currentCell.playPauseBtn.setImage(UIImage(named: "play-icon"), for: .normal)
                } else {
                    player?.play()
                    currentCell.playPauseBtn.setImage(UIImage(named: "pause-icon"), for: .normal)
                }
            } else {
                if(previousSelectedPath != nil) {
                    let previousCell = tableView.cellForRow(at: previousSelectedPath!) as! MusicTableViewCell
                    previousCell.playPauseBtn.setImage(UIImage(named: "play-icon"), for: .normal)
                }
                let playerItem = AVPlayerItem(url:tracks[indexPath!.row].trackURL)
                player = AVPlayer(playerItem:playerItem)
                player!.rate = 1.0
                player!.play()
                currentCell.playPauseBtn.setImage(UIImage(named: "pause-icon"), for: .normal)
            }
            previousSelectedPath = indexPath!
        }
    }
    
    // MARK: - Search Bar Delegate
    
    @IBAction func searchMusic(_ sender: Any) {
        musicSearchBar.endEditing(true)
        guard let searchText = musicSearchBar.text else {
            return
        }
        fetchItems(with: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {
            return
        }
        fetchItems(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        musicSearchBar.endEditing(true)
        guard let searchText = searchBar.text else {
            return
        }
        fetchItems(with: searchText)
    }
    
    // - Data Parse and Display
    
    func fetchItems(with term: String) {
        let queries: [String: String] = [
            "term":"\(String(term))",
            "media":"music",
            "entity":"song",
        ]
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        datafetcher.fetchItems(matching: queries) { (tracks) in
            guard let tracks = tracks else {
                return
            }
            self.updateUI(with: tracks)
        }
    }
    
    func updateUI(with tracks: [Track]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            if(tracks.count == 0) {
                self.musicTableView.isHidden = true
            } else {
                self.tracks = tracks
                self.musicTableView.isHidden = false
                self.musicTableView.reloadData()
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchItems(with: musicSearchBar.text!)
        refreshControl.endRefreshing()
    }
}

