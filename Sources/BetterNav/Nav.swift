//
//  Nav.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public final class Nav: ObservableObject {
    
    public enum Action {
        case open
        case back
    }
    
    static var navs = [String: Nav]()

    var id: String

    @Published var stack = [Viewable]()
    @Published var stackPosition = 0
    
    @Published public var currentViewable: Viewable?
    
    @Published public var currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    
    public init(id: String) {
        self.id = id
        Nav.navs[id] = self
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
        
        nav.stack.removeAll()
        nav.stackPosition = 1
        nav.stack.append(view)
        nav.setView(view)
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
}


