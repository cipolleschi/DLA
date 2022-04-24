//
//  DLAApp.swift
//  DLA
//
//  Created by Riccardo Cipolleschi on 23/04/2022.
//

import SwiftUI

protocol DeepLinkParser {
    func canHandleDeepLink(_ urlComponents: URLComponents) -> Bool
    func handleDeepLink(_ urlComponents: URLComponents)
}

//@main
struct DLAAppWithAnyType: App {
    @State var selectedTab: String = "Products"
    @State var selectedProduct: Int? = nil

    var tabRepresentations: [TabRepresentation] {
        return [
            .init(
                title: "Products",
                view: ProductList(
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
                ).asAnyView
            ),
            .init(title: "Settings", view: Text("Settings").asAnyView)
        ]
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(
                tabs: tabRepresentations,
                selectedTab: $selectedTab
            )
            .onOpenURL { url in
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                    return
                }

                let deepLinker = TabDeepLinkParser(
                    tabRepresentations: tabRepresentations,
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
