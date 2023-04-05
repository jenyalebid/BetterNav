//
//  BetterNavStack.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/8/23.
//

import SwiftUI

public struct BetterNavStack<Content: View, BeforeNavContent: View, AfterNavContent: View>: View {
    
    @ObservedObject var nav: Nav
    
    var content: Content
    var beforeNav: BeforeNavContent
    var afterNav: AfterNavContent
    
    public init(nav: Nav, @ViewBuilder content: () -> Content, @ViewBuilder beforeNav: () -> BeforeNavContent, @ViewBuilder afterNav: () -> AfterNavContent) {
        self.nav = nav
        self.content = content()
        self.beforeNav = beforeNav()
        self.afterNav = afterNav()
    }
    
    public var body: some View {
        NavigationView {
            content
                .modifier(NavModifier(nav: nav, beforeNav: beforeNav, afterNav: afterNav))
        }
        .navigationViewStyle(.stack)
    }
}
