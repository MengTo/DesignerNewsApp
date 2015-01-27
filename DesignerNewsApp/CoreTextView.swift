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

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func linkDidTap(sender: DTLinkButton) {
        if let url = sender.URL {
            if let delegate = self.linkDelegate {
                delegate.coreTextView(self, linkDidTap: url)
            } else {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }

    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttributedString string: NSAttributedString!, frame: CGRect) -> UIView! {

        let attributes = string.attributesAtIndex(0, effectiveRange: nil)
        let url = attributes[DTLinkAttribute] as? NSURL
        let identifier = attributes[DTGUIDAttribute] as? String

        let button = DTLinkButton(frame: frame)
        button.URL = url
        button.GUID = identifier
        button.minimumHitSize = CGSizeMake(25, 25)
        button.addTarget(self, action: "linkDidTap:", forControlEvents: .TouchUpInside)

        return button
    }

}
