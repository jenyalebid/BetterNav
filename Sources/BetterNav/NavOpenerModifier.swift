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
        HStack(spacing: 12) {
            backward
            forward
        }
        .padding(.leading, 6)
    }
    
    var backward: some View {
        Button {
            nav.goBack()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.plain)
        .disabled(nav.stackPosition == 1)
    }
    
    var forward: some View {
        Button {
            nav.goForward()
        } label: {
            Image(systemName: "chevron.forward")
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.plain)
        .disabled((nav.isInRootView && nav.stack.count == 1) || nav.stackPosition == nav.stack.count)
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
    }
}

//struct NavModifier_Previews: PreviewProvider {
//
//    //    class NavTestViewer: NavViewer {
//    //        func viewType(for object: Viewable?) -> NavModifier_Previews.InnerNavView {
//    //            InnerNavView(object: object)
//    //        }
//    //    }
//
//    struct ViewableTest: Viewable {
//
//        var viewID = UUID()
//        var viewName: String? {
//            nil
//        }
//    }
    
//    struct NavTester: View {
//
//        @StateObject var nav = Nav(id: "Main")
//
//        var body: some View {
//
//            BetterNavStack(nav: nav) {
//                InnerNavView(object: $nav.currentViewable)
//            } beforeNav: {
//
//            }
//            .navigationViewStyle(.stack)
//        }
//    }
    
//    struct InnerNavView: NavHost {
//
//        @Binding var object: Viewable?
//
//        var body: some View {
//            VStack {
//                Spacer()
//                Text("View Inner #\(Int.random(in: 0...100))")
//                Spacer()
//                Button {
//                    Nav.openView(for: ViewableTest(), in: "Main")
//                } label: {
//                    Text("Next View")
//                }
//                Spacer()
//            }
//            .padding()
//            .transition(.slide)
//        }
//    }
    
    //    struct LocalNavModifier: NavModifierProtocol {
    //
    //        public var nav: Nav
    //
    //        func body(content: Content) -> some View {
    //            content
    //                .modifier(NavModifier(nav: nav, viewer: NavTestViewer(), modifier: self) {
    //
    //                })
    //        }
    //    }
    
//    static var previews: some View {
//        NavTester()
//    }
//}


