//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Tobias Helmrich on 11.03.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL
    var title: String!
    
    init(filePathUrl: NSURL, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
