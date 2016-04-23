//
//  DataService.swift
//  bensocial-showcase-dev
//
//  Created by Baynham Makusha on 4/23/16.
//  Copyright © 2016 Ben Makusha. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://bensocial-showcase.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}