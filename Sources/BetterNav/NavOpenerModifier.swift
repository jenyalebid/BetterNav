//
//  NavOpenerModifier.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public struct NavModifier<BeforeNavContent: View>: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject public var nav: Nav
    @State var navPosition: Int
    
    @State var object: Viewable?
    
    var beforeNav: BeforeNavContent
    
    public init(nav: Nav, beforeNav: BeforeNavContent) {
        self.nav = nav
        self.beforeNav = beforeNav
        self._navPosition = State(wrappedValue: nav.stackPosition)
    }
    
    public func body(content: Content) -> some View {
        content
//            .transition(nav.currentTransition)
//            .id(nav.currentViewable?.viewID)
            .animation(.spring(), value: nav.currentViewable?.viewID)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    navTitle()
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    beforeNav
                    navButtons
                }
            }
    }
}

extension NavModifier {
    
    var navButtons: some View {
        HStack(spacing: 14) {
            backward
            forward
        }
        .padding(.leading, 8)
    }
    
    var backward: some View {
        NavButton(image: "chevron.left.circle") {
            nav.goBack()
        }
        .disabled(nav.isInRootView)
    }
    
    var forward: some View {
        NavButton(image: "chevron.right.circle") {
            nav.goForward()
        }
        .disabled(nav.isInLastView)
    }
    
    func navTitle() -> some View {
        HStack {
            let title = nav.currentViewable?.title
            if let image = title?.image {
                image
            }
            if let text = title?.text {
                Text(text)
            }
        }
        .frame(maxWidth: 300)
    }
}

extension NavModifier {
    
    struct NavButton: View {
        
        var image: String
        var action: () -> ()
        
        var body: some View {
            Button {
                action()
            } label: {
                Image(systemName: image)
                    .foregroundColor(.accentColor)
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
    }
}

struct NavModifier_Previews: PreviewProvider {

    struct ViewableTest: Viewable {
        var parent: Viewable? = nil
        
        var navName: String = ""
        

        var viewID = UUID()
        var viewName: String? {
            nil
        }
    }
    
    struct NavTester: View {

        @StateObject var nav = Nav(id: "Main", rootView: nil)

        var body: some View {

            BetterNavStack(nav: nav) {
                InnerNavView(nav: nav)
            } beforeNav: {

            }
            .navigationViewStyle(.stack)
        }
    }
    
    struct InnerNavView: NavHost {

        @ObservedObject var nav: Nav

        var body: some View {
            VStack {
                Spacer()
                Text("View Inner #\(Int.random(in: 0...100))")
                Spacer()
                Button {
                    Nav.openView(for: ViewableTest(), in: "Main")
                } label: {
                    Text("Next View")
                }
                Spacer()
            }
            .padding()
            .transition(.slide)
        }
    }
    
//        struct LocalNavModifier: NavModifierProtocol {
//
//            public var nav: Nav
//
//            func body(content: Content) -> some View {
//                content
//                    .modifier(NavModifier(nav: nav, viewer: NavTestViewer(), modifier: self) {
//
//                    })
//            }
//        }
    
    static var previews: some View {
        NavTester()
    }
}


