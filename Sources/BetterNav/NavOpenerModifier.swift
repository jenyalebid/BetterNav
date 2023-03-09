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
        
        NavigationView {
            content
                .id(nav.currentViewable?.viewID)
                .animation(.spring(), value: nav.currentViewable?.viewID)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        beforeNav
                        navButtons
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}

//extension NavModifier {
//    
//    func open(info: NotificationCenter.Publisher.Output) {
//        guard let object = info.object as? Viewable else {
//            return
//        }
//        nav.currentViewable = object
//    }
//}

extension NavModifier {
    
    var navButtons: some View {
        HStack(spacing: 6) {
            backward
            forward
        }
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
}

//struct NavModifier_Previews: PreviewProvider {
//    
//    static var viewNumber = 0
//    
//    class NavTestViewer: NavViewer {
//        func viewType(for object: Viewable?) -> NavModifier_Previews.InnerNavView {
//            InnerNavView(object: object)
//        }
//    }
//    
//    struct ViewableTest: Viewable {
//        
//    }
//    
//    struct NavTester: View {
//        
//        var body: some View {
//            BetterNavStack(nav: LocalNavModifier(nav: Nav(id: "Main"))) {
//                InnerNavView()
//            }
//            .navigationViewStyle(.stack)
//        }
//    }
//    
//    struct InnerNavView: NavHost {
//        
//        var object: Viewable?
//        
//        var body: some View {
//            VStack {
//                Spacer()
//                Text("View Inner #\(Int.random(in: 0...100))")
//                Spacer()
//                Button {
//                    Nav.openView(for: object!, in: "Main")
//                } label: {
//                    Text("Next View")
//                }
//                Spacer()
//            }
//            .padding()
//        }
//        
//    }
//    
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
//    
//    static var previews: some View {
//        NavTester()
//    }
//}


