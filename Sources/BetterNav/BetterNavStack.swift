//
//  BetterNavStack.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/8/23.
//

import SwiftUI

public struct BetterNavStack<Content: View, BeforeNavContent: View>: View {
    
    @ObservedObject var nav: Nav
    
    var content: Content
    var beforeNav: BeforeNavContent
    
    public init(nav: Nav, @ViewBuilder content: () -> Content, @ViewBuilder beforeNav: () -> BeforeNavContent) {
        self.nav = nav
        self.content = content()
        self.beforeNav = beforeNav()
    }
    
    public var body: some View {
        NavigationView {
            content
                .modifier(NavModifier(nav: nav, beforeNav: beforeNav))
        }
    }
}
