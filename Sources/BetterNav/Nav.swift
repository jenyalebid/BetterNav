//
//  Nav.swift
//  AlpineUI
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI


// Generic - Faster
//public protocol NavViewer {
//    func viewType<Content: NavHost>(as content: Content.Type, for _: Viewable?) -> Content
//}

// Existential - Slower
public protocol NavViewer {
    associatedtype Content: View

    func viewType(for _: Viewable?) -> Content
}

public protocol NavHost: View {
    var object: Viewable? { get }
}

public final class Nav {

    static public var stack = [Viewable]()
    static var stackCount = 0
}

public extension Nav {
    
    static var last: Viewable? {
        Nav.stack.last
    }
    
    static func openView(for object: Viewable) {
        Self.stack.append(object)
        NotificationCenter.default.post(Notification(name: Notification.Name("Nav_Object_Open"), object: object, userInfo: ["postion": Self.stack.count - 1]))
    }
    
    static func goBack() {
        NotificationCenter.default.post(Notification(name: Notification.Name("Nav_Move"), userInfo: ["direction": "back"]))
    }
    
    static func goForward() {
        NotificationCenter.default.post(Notification(name: Notification.Name("Nav_Move"), userInfo: ["direction": "forward"]))
    }
}

//struct Na: NavHost {
//
//    var object: Viewable?
//
//    var body: some View {
//        EmptyView()
//    }
//}
//
//class bb: NN {
//
//    func h(_: Viewable) -> Na {
//        Na(object: vs.last)
//    }
//    typealias Content = Na
//
//    var vs: [Viewable] = []
//}


