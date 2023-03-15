//
//  Viewables.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/15/23.
//

import SwiftUI

public class Viewables {
    
    public struct Title {
        
        public init(text: String?, image: Image?) {
            self.text = text
            self.image = image
        }
        
        var text: String?
        var image: Image?
    }
}
