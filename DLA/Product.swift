//
//  Product.swift
//  DLA
//
//  Created by Riccardo Cipolleschi on 23/04/2022.
//

import SwiftUI

struct Product {
    var productId: Int
    var title: String
    var description: String {
        """
        This is a long description for product with id: \(productId).
        The product title is \(title).

        This is a very cool product and you should really buy it!
        """
    }
}

struct ProductView: View {

    @State var product: Product

    init(id: Int) {
        self.product = Product(
            productId: id,
            title: "The Product \(id)"
        )
    }

    var body: some View {
        VStack {
            Text(product.description)
                .navigationTitle(product.title)
            Spacer()
        }
    }
}

struct Product_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(id: 1)
    }
}
