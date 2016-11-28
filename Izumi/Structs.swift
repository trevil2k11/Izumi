//
//  Structs.swift
//  Izumi
//
//  Created by Ilya Kosolapov on 07.06.16.
//  Copyright © 2016 Ilya Kosolapov. All rights reserved.
//

import Foundation
import UIKit

struct thing {
    var imageName: String?
    var part: String?
    var image: String?
    var imgId: String?
    
    init(name: String, part: String, img: String, id: String) {
        self.imageName = name
        self.part = part
        self.image = img
        self.imgId = id
    }
}