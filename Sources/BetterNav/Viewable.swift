//
//  Viewable.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public protocol Viewable {
    
    var nav: Nav? { get set }
}

public extension Viewable {
    
    var nav: Nav? {
        get {
            nil
        }
        set {
            self.nav = newValue
        }
    }
}

public protocol NavModifierProtocol: ViewModifier {
    
    var nav: Nav { get set }
}

// Generic - Faster
public protocol NavViewerGeneric {
    func viewType<Content: NavHost>(as content: Content.Type, for _: Viewable?) -> Content
}

// Existential - Slower
public protocol NavViewer {
    associatedtype Content: NavHost
    
    func viewType(for _: Viewable?) -> Content
}

public protocol NavHost: View {
    var object: Viewable? { get }
}
