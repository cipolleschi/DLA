//
//  DLAApp.swift
//  DLA
//
//  Created by Riccardo Cipolleschi on 23/04/2022.
//

import SwiftUI

@main
struct DLAAppWithNoTypeErasure: App {
    @State var selectedTab: String = "Products"
    @State var selectedProduct: Int? = nil

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                // First Tab
                ProductList(
                    productList: (0..<100).map {
                        ProductMetadata(
                            title: "P\($0)",
                            price: "£ \($0+1 * 10)",
                            id: $0
                        )
                    },
                    destinationFactory: { id in
                        ProductView(id: id)
                    },
                    selectedId: $selectedProduct
                ).tabItem {
                    Text("Products")
                }.tag("Products")

                // Second Tab
                Text("Profile").tabItem {
                    Text("Profile")
                }.tag("Profile")
            }
            .onOpenURL { url in
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                    return
                }

                // Tab representations are not needed in this case,
                // but we can reuse part of the code.
                // The view property is not used
                let deepLinker = TabDeepLinkParser(
                    tabRepresentations: [
                        .init(title: "Products", view: Text("P").asAnyView),
                        .init(title: "Profile", view: Text("S").asAnyView)
                    ],
                    childrens: [
                        ProductDeepLinkParser(action: { productId in
                            self.selectedProduct = productId
                        })
                    ],
                    action: { selectedTab in
                        self.selectedTab = selectedTab
                    }
                )

                guard deepLinker.canHandleDeepLink(components) else {
                    return
                }

                deepLinker.handleDeepLink(components)
            }
        }
    }
}
