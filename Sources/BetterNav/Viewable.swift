//
//  Viewable.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public protocol Viewable {
    
    var viewID: UUID { get }
    var viewName: String? { get }
    
    var parent: Viewable? { get }
    var title: Viewables.Title? { get }
    
    var navName: String { get }
    var nav: Nav? { get }
    
    func view<Content: View>(_: Content) -> Content?
}

public extension Viewable {
    
    var nav: Nav? {
        get {
            Nav.getNav(for: navName)
        }
    }
    
    var title: Viewables.Title? {
        nil
    }
    
    func view<Content>(_: Content) -> Content? where Content : View {
        nil
    }
    
    func open() {
        guard let nav else {
            return
        }
        
        nav.openView(for: self)
    }
}

public protocol NavModifierProtocol: ViewModifier {
    
    var nav: Nav { get set }
}

public protocol NavHost: View {
    var nav: Nav { get }
}

// Generic - Faster
//public protocol NavViewerGeneric {
//    func viewType<Content: NavHost>(as content: Content.Type, for _: Viewable?) -> Content
//}
//
// Existential - Slower
//public protocol NavViewer {
//    associatedtype Content: NavHost
//
//    func viewType(for _: Viewable?) -> Content
//}
//
