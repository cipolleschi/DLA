//
//  MainTabView.swift
//  DLA
//
//  Created by Riccardo Cipolleschi on 23/04/2022.
//

import SwiftUI

class TabDeepLinkParser: DeepLinkParser {
    let tabRepresentations: [TabRepresentation]
    let childrens: [DeepLinkParser]
    let action: (String) -> ()

    init(tabRepresentations: [TabRepresentation], childrens: [DeepLinkParser], action: @escaping (String) -> ()) {
        self.tabRepresentations = tabRepresentations
        self.childrens = childrens
        self.action = action
    }

    func canHandleDeepLink(_ urlComponents: URLComponents) -> Bool {
        guard let host = urlComponents.host else {
            return false
        }
        return tabRepresentations.map(\.title).contains(host)
    }

    func handleDeepLink(_ urlComponents: URLComponents) {
        guard let host = urlComponents.host else {
            return
        }
        action(host)
        for children in childrens where children.canHandleDeepLink(urlComponents) {
            children.handleDeepLink(urlComponents)
        }
    }
}

struct TabRepresentation: Identifiable {
    var title: String
    var view: AnyView
}

extension TabRepresentation {
    var id: String { return title }
}

struct MainTabView: View {
    @State var tabs: [TabRepresentation]
    @Binding var selectedTab: String
//    @State var selectedTab: String

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabs) { tab in
                tab.view
                    .tabItem {
                        Text(tab.title)
                    }
                    .tag(tab.title)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var selectedTab: String = "History"
    static var previews: some View {
        MainTabView(
            tabs: [
                .init(
                    title: "Products",
                    view: Text("Products").asAnyView
                ),
                .init(
                    title: "History",
                    view: Text("History").asAnyView
                ),
                .init(
                    title: "Profile",
                    view: Text("Profile").asAnyView
                ),
                .init(
                    title: "Settings",
                    view: Text("Settings").asAnyView
                )
            ],
//            selectedTab: "Settings"

            selectedTab: Binding(get: {
                return Self.selectedTab
            }, set: { selectedTab in
                Self.selectedTab = selectedTab
            })
        )
    }
}

extension View {
    var asAnyView: AnyView {
        return AnyView(self)
    }
}
