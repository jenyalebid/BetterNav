//
//  Nav.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public final class Nav: ObservableObject {
    
    static var navs = [String: Nav]()
    
//    struct NoNav: Viewable {
//        var viewID = UUID()
//        var viewName: String? = nil
//        var view: AnyView
//    }

    var id: String

    @Published var stack = [Viewable]()
    @Published var stackPosition = 0
    
    @Published public var currentViewable: Viewable?
    
    
    @Published public var currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    
    public init(id: String, rootView: Viewable?) {
        self.id = id
        Nav.navs[id] = self
        
        if let rootView {
            setRootView(rootView)
        }
    }
    
    func setView(_ view: Viewable) {
        DispatchQueue.main.async { [self] in
            withAnimation {
                currentViewable = view
            }
        }
    }
}

extension Nav {
    
    var isInRootView: Bool {
        stackPosition == 1
    }
    
    var isInLastView: Bool {
        !isInRootView && stackPosition == stack.count
    }
}

public extension Nav {
    
    static func openView(for object: Viewable, in nav: String) {
        guard let nav = Nav.navs[nav] else {
            return
        }
        
        nav.currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        
        nav.stack.removeLast(nav.stack.count - nav.stackPosition)
        nav.stack.append(object)
        nav.stackPosition += 1
        nav.setView(object)
    }
    
    static func setRootView(_ view: Viewable, in nav: String) {
        guard let nav = Nav.navs[nav] else {
            return
        }
        nav.setRootView(view)
    }
    
    static func goBack(in nav: String) {
        guard let nav = Nav.navs[nav] else {
            return
        }
        nav.goBack()
    }
    
    static func goForward(in nav: String) {
        guard let nav = Nav.navs[nav] else {
            return
        }
        nav.goForward()
    }
    
//    static func present(_ view: any View, in nav: String) {
//        guard let nav = Nav.navs[nav] else {
//            return
//        }
//
//        let nonNav = NoNav(view: AnyView(view))
//        nav.currentViewable = nonNav
//    }
}

public extension Nav {
    
    var last: Viewable? {
        stack.last
    }

    func goBack() {
        guard !isInRootView else { return }
        currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
        stackPosition -= 1
        setView(stack[stackPosition - 1])
    }
    
    func goForward() {
        guard stackPosition != stack.count else { return }
        currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        stackPosition += 1
        setView(stack[stackPosition - 1])
    }
    
    func setRootView(_ view: Viewable) {
        stack.removeAll()
        stackPosition = 1
        stack.append(view)
        currentViewable = view
    }
}


