//
//  ProductList.swift
//  DLA
//
//  Created by Riccardo Cipolleschi on 23/04/2022.
//

import SwiftUI

class ProductDeepLinkParser: DeepLinkParser {

    var action: (Int) -> ()

    init(action: @escaping (Int) ->()) {
        self.action = action
    }

    func canHandleDeepLink(_ urlComponents: URLComponents) -> Bool {
        return urlComponents.queryItems?.contains {
            $0.name == "id"
        } ?? false
    }

    func handleDeepLink(_ urlComponents: URLComponents) {
        let idQueryItem = urlComponents.queryItems?.first {
            $0.name == "id"
        }
        guard
            let value = idQueryItem?.value,
            let id = Int(value)
        else {
            return
        }
        action(id)
    }

}

struct ProductMetadata: Identifiable {
    let title: String
    let price: String
    let id: Int
}

protocol ViewWithIntId: View {
    init(id: Int)
}

struct ProductList<Destination: View>: View {
    @State var productList: [ProductMetadata]
    var destinationFactory: (Int) -> Destination
    @Binding var selectedId: Int?

    var body: some View {
        NavigationView {
            List(productList) { product in
                NavigationLink(
                    tag: product.id,
                    selection: $selectedId,
                    destination: {
                        destinationFactory(product.id)
                    },
                    label: {
                        cell(product: product)
                    }
                )
            }
        }
    }

    func cell(product: ProductMetadata) -> some View {
        return HStack {
            Text(product.title)
            Spacer()
            Text(product.price)
        }
    }
}



struct ProductList_Previews: PreviewProvider {
    static var selectedId: Int? = nil
    static var previews: some View {
        ProductList(
            productList: (0...10).map {
                return ProductMetadata(
                    title: "Product \($0)",
                    price: "£ \(String(format: "%.2f", Double.random(in: 0..<1000)))",
                    id: $0)
            },
            destinationFactory: { id in
                Text("\(id). Product")
            },
            selectedId: .init(get: {
                return Self.selectedId
            }, set: { id in
                Self.selectedId = id
            })
        )
    }
}
