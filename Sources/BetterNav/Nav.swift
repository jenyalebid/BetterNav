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
    
    public init(id: String) {
        self.id = id
        Nav.navs[id] = self
    }
}

extension Nav {
    
    var isInRootView: Bool {
        stackPosition == 0
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
        nav.stack.append(object)
        nav.stackPosition = nav.stack.count
        NotificationCenter.default.post(Notification(name: Notification.Name("Nav_Action"), object: object, userInfo: ["action": Nav.Action.open]))
    }
}

public extension Nav {
    
    var last: Viewable? {
        stack.last
    }

    func goBack() {
        guard !isInRootView else { return }
        
        stackPosition -= 1
        NotificationCenter.default.post(Notification(name: Notification.Name("Nav_Action"), userInfo: ["action": Nav.Action.back]))
    }
    
    func goForward() {
        guard stackPosition != stack.count else { return }
        
        stackPosition += 1
        NotificationCenter.default.post(Notification(name: Notification.Name("Nav_Action"), object: stack[stackPosition - 1], userInfo: ["action": Nav.Action.open]))

    }
}


