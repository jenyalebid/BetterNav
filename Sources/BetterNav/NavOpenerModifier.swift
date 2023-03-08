//
//  NavOpenerModifier.swift
//  BetterNav
//
//  Created by Jenya Lebid on 3/7/23.
//

import SwiftUI

public struct NavModifier<Viewer: NavViewer, LocalNavModifier: ViewModifier, BeforeNavContent: View>: NavModifierProtocol {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject public var nav: Nav
    
    @State var isActive = true
    @State var navPosition: Int
    
    @State var open = false
    @State var object: Viewable? = nil
        
    var viewer: Viewer
    
    var modifier: LocalNavModifier
    var beforeNav: BeforeNavContent
    
    public init(nav: Nav, viewer: Viewer, modifier: LocalNavModifier, @ViewBuilder beforeNav: () -> BeforeNavContent) {
        self.nav = nav
        self.viewer = viewer
        self.modifier = modifier
        self.beforeNav = beforeNav()
        
        self._navPosition = State(wrappedValue: nav.stackPosition)
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                isActive = true
            }
            .onDisappear {
                isActive = false
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    beforeNav
                    navButtons
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Nav_Action"))) { info in
                guard isActive else {
                    return
                }
                computeAction(for: info)
            }
            .background(
                NavigationLink(isActive: $open, destination: {
                    viewer.viewType(for: object)
                        .modifier(modifier)
                        .navigationBarBackButtonHidden(true)
                }, label: {
                    EmptyView()
                })
            )
    }
}

extension NavModifier {
    
    func computeAction(for info: NotificationCenter.Publisher.Output) {
        guard let action = info.userInfo?.values.first as? Nav.Action else {
            return
        }
        
        switch action {
        case .open:
            open(info: info)
        case .back:
            dismiss()
        }
    }
    
    func open(info: NotificationCenter.Publisher.Output) {
        guard let object = info.object as? Viewable else {
            return
        }

        self.object = object
        self.open = true
    }
}

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
        .disabled(nav.stackPosition == 0)
    }
    
    var forward: some View {
        Button {
            nav.goForward()
        } label: {
            Image(systemName: "chevron.forward")
                .foregroundColor(.accentColor)
        }
        .buttonStyle(.plain)
        .disabled(nav.stackPosition == nav.stack.count)
    }
}

struct NavModifier_Previews: PreviewProvider {
    
    static var viewNumber = 0
    
    class NavTestViewer: NavViewer {
        func viewType(for object: Viewable?) -> NavModifier_Previews.InnerNavView {
            InnerNavView(object: object)
        }
    }
    
    struct ViewableTest: Viewable {

    }
    
    struct NavTester: View {
        
        var body: some View {
            BetterNavStack(nav: LocalNavModifier(nav: Nav(id: "Main"))) {
                InnerNavView()
            }
            .navigationViewStyle(.stack)
        }
    }
    
    struct InnerNavView: NavHost {
        
        var object: Viewable?
        
        var body: some View {
            VStack {
                Spacer()
                Text("View Inner #\(Int.random(in: 0...100))")
                Spacer()
                Button {
                    Nav.openView(for: object!, in: "Main")
                } label: {
                    Text("Next View")
                }
                Spacer()
            }
            .padding()
        }

    }
    
    struct LocalNavModifier: NavModifierProtocol {
        
        public var nav: Nav
        
        func body(content: Content) -> some View {
            content
                .modifier(NavModifier(nav: nav, viewer: NavTestViewer(), modifier: self) {
                    
                })
        }
    }
    
    static var previews: some View {
        NavTester()
    }
}


