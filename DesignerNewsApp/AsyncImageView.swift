//
//  AsyncImageView.swift
//  DesignerNewsApp
//
//  Created by James Tang on 28/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

public class AsyncImageView: UIImageView {

    var placeholderImage : UIImage?

    var url : NSURL? {
        didSet {
            self.image = placeholderImage
            if let urlString = url?.absoluteString {
                ImageLoader.sharedLoader.imageForUrl(urlString) { [weak self] image, url in
                    if let strongSelf = self {
                        if strongSelf.url?.absoluteString == url {
                            strongSelf.image = image
                        }
                    }
                }
            }
        }
    }

    func setURL(url: NSURL?, placeholderImage: UIImage?) {
        self.placeholderImage = placeholderImage
        self.url = url
    }

}
