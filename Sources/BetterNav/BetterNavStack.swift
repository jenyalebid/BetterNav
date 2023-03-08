//
//  BetterNavStack.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/8/23.
//

import SwiftUI

public struct BetterNavStack<LocalNav: ViewModifier, Content: View>: View {
    
    var localNav: LocalNav
    var content: Content
    
    public init(nav: LocalNav, @ViewBuilder content: () -> Content) {
        self.localNav = nav
        self.content = content()
    }
    
    public var body: some View {
        NavigationView {
            content
                .modifier(localNav)
        }
    }
}
