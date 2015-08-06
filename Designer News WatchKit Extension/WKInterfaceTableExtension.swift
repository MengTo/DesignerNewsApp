//
//  WKInterfaceTableExtension.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 09.07.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import WatchKit

extension WKInterfaceTable {
    enum RowType: String {
        case StoryRowController = "StoryRowController"
    }

    func setNumberOfRows(numberOfRows: Int, withRowType rowType: RowType) {
        setNumberOfRows(numberOfRows, withRowType: rowType.rawValue)
    }
}