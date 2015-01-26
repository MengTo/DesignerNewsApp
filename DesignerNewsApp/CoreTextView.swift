//
//  CoreTextView.swift
//  DesignerNewsApp
//
//  Created by James Tang on 26/1/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit

protocol CoreTextViewDelegate : class {
    func coreTextView(textView: CoreTextView, linkDidTap link:NSURL)
}

class CoreTextView: DTAttributedTextContentView, DTAttributedTextContentViewDelegate {

    weak var linkDelegate : CoreTextViewDelegate?
    var textView : DTAttributedTextView!
    var url : NSURL?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func linkDidTap(sender: AnyObject) {
        if let url = self.url {
            if let delegate = self.linkDelegate {
                delegate.coreTextView(self, linkDidTap: url)
            } else {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForLink url: NSURL!, identifier: String!, frame: CGRect) -> UIView! {
        self.url = url
        let button = UIButton.buttonWithType(.Custom) as UIButton
        button.frame = frame
        button.addTarget(self, action: "linkDidTap:", forControlEvents: .TouchUpInside)
        return button
    }

}
