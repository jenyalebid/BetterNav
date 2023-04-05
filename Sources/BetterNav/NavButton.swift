//
//  NavButton.swift
//  BetterNav
//
//  Created by Jenya Lebid on 4/5/23.
//

import SwiftUI

public struct NavButton: View {
    
    public init(image: String, action: @escaping () -> ()) {
        self.image = image
        self.action = action
    }
    
    var image: String
    var action: () -> ()
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: image)
                .foregroundColor(.accentColor)
                .font(.headline)
        }
        .buttonStyle(.plain)
    }
}
