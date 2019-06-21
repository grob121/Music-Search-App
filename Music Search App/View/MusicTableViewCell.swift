//
//  MusicTableViewCell.swift
//  Music Search App
//
//  Created by Allan Pagdanganan on 21/06/2019.
//  Copyright © 2019 Allan Pagdanganan. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {


    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLbl: UILabel!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var albumNameLbl: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
}
