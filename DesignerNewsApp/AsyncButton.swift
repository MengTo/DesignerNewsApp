//
//  AsyncButton.swift
//  DesignerNewsApp
//
//  Created by James Tang on 1/3/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

class AsyncButton: UIButton {

    private var imageURL = [UInt:NSURL]()
    private var placeholderImage = [UInt:UIImage]()


    func setImageURL(url: NSURL?, placeholderImage placeholder:UIImage?, forState state:UIControlState) {

        imageURL[state.rawValue] = url
        placeholderImage[state.rawValue] = placeholder

        if let urlString = url?.absoluteString {
            ImageLoader.sharedLoader.imageForUrl(urlString) { [weak self] image, url in

                if let strongSelf = self {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if strongSelf.imageURL[state.rawValue]?.absoluteString == url {
                            strongSelf.setImage(image, forState: state)
                        }
                    })
                }
            }
        }
    }

}
