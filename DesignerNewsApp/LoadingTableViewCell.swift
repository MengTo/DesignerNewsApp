//
//  LoadingTableViewCell.swift
//  DesignerNewsApp
//
//  Created by James Tang on 28/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.loadingIndicator.startAnimating()
    }

    func startAnimating() {
        self.loadingIndicator.startAnimating()
    }

    func stopAnimating() {
        self.loadingIndicator.stopAnimating()
    }

}
