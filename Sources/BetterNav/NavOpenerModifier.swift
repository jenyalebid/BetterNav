//
//  NavOpenerModifier.swift
//  AlpineUI
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public struct NavModifier<Viewer: NavViewer>: ViewModifier {
    
    @ObservedObject var control = NavControl.shared
    
    @State var open = false
    @State var object: Viewable? = nil
    
    var position = Nav.stack.count
    
    var viewer: Viewer
    
    public init(viewer: Viewer) {
        self.viewer = viewer
    }
    
    public func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    menu
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Nav_Object_Open"))) { info in
                guard let position = info.userInfo?.values.first as? Int else {
                    return
                }
                guard self.position == position else {
                    return
                }
                guard let object = info.object as? Viewable else {
                    return
                }

                self.object = object
                open = true
            }
            .background(
                NavigationLink(isActive: $open, destination: {
                    viewer.viewType(for: object)
                }, label: {
                    EmptyView()
                })
            )
    }
    
    var menu: some View {
        Button {
            withAnimation(.easeIn) {
                control.sidebar.toggle()
            }
        } label: {
            Image(systemName: "sidebar.left")
        }
    }
    
    var back: some View {
        Button {
            withAnimation(.easeIn) {
                
            }
        } label: {
            Image(systemName: "chevron.backward")
        }
    }
}


