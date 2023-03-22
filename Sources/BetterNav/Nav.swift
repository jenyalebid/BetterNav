//
//  Nav.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public final class Nav: ObservableObject {
    
    public enum PreviousPosition {
        case before
        case after
    }
    
    static var navs = [String: Nav]()
    
    var id: String

    @Published var stack = [Viewable]()
    @Published var stackPosition = 0
    
    @Published public var currentViewable: Viewable?
    
    @Published public var currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    
    public init(id: String, rootView: Viewable?) {
        self.id = id
        Nav.navs[id] = self
        
        setRootView(rootView)
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
        stackPosition <= 1
    }
    
    var isInLastView: Bool {
        !isInRootView && stackPosition == stack.count || stack.count <= 1
    }
}

public extension Nav {
    
    static func getNav(for nav: String) -> Nav? {
        Nav.navs[nav]
    }
    
    static func clearStack(for nav: String) {
        guard let nav = Nav.navs[nav] else {
            return
        }
        
        nav.clearStack()
    }
    
    static func isPrevious(in nav: String, for view: Viewable) -> PreviousPosition? {
        guard let nav = Nav.navs[nav] else {
            return nil
        }
        if !nav.isInLastView {
            return nav.stack[nav.stackPosition].viewID == view.viewID ? .after : nil
        }
        if !nav.isInRootView {
            return nav.stack[nav.stackPosition - 2].viewID == view.viewID ? .before : nil
        }
        return nil
    }
    
    static func openView(for object: Viewable, in nav: String) {
        guard let nav = Nav.navs[nav] else {
            return
        }
        
        nav.openView(for: object)
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
        guard !isInLastView else { return }
        
        currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        stackPosition += 1
        setView(stack[stackPosition - 1])
    }
    
    func setRootView(_ view: Viewable?) {
        stack.removeAll()
        stackPosition = 1
        if let view {
            stack.append(view)
        }
        currentViewable = view
    }
    
    func openView(for object: Viewable) {
        currentTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
        let removeCount = stack.count - stackPosition
        if removeCount >= 0 {
            stack.removeLast(removeCount)
            stack.append(object)
            stackPosition += 1
            setView(object)
        }
        else {
            setRootView(object)
        }
    }
    
    func clearStack() {
        stack.removeAll()
        stackPosition = 1
        if let currentViewable {
            stack.append(currentViewable)
        }
        else {
            currentViewable = nil
        }
    }
}


