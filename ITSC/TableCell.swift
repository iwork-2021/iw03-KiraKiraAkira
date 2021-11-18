//
//  TableCell.swift
//  ITSC
//
//  Created by KiraKiraAkira on 2021/11/18.
//

import UIKit

class TableCell: NSObject {
    var title:String
    var date:String
    var website:String
    init(t:String,d:String,w:String) {
        self.title=t
        self.date=d
        self.website=w
    }
}
