# DeepLink App in SwiftUI

This app is a showcase of how we can develop an app using SwiftUI which supports DeepLinks.

## Requirements

* The app must support DeepLinks
* DeepLinks can be deeply nested
* Features must be developed in isolation
* Types should not leak outside their boundaries
* There is a single CompositionRoot, the App (It can be split in multiple composers, of course)
* Stretch - Should not use AnyView.

## Structure

The app has a main `TabBar` with two tabs: `Products` and `Settings/Profile`. The `Products` tab contains a list of products: tapping on a product loads its description.

The tabs can be opened using deep links. The DL scheme is `dla://`.

The app has two entry points:
* `DLAAppWithAnyType` - which drops the last requirement and let us create a TabBar with a dynamic number of tabs.
* `DLAAppWithNoTypeErasure` - which sacrifices the possibility to dynamically specify the tabs to drop the type erasure.

If we accept that the CompositionRoot directly allocates all the tabs, we can avoid the usage of `AnyView`.

### Supported DeepLinks

When using `DLAAppWithAnyType`:
* `dla://Products?id=<int>`: it loads the product with `productId == <int>`
* `dla://Settings`: it loads the settings tab

When using `DLAAppWithNoTypeErasure`:
* `dla://Products?id=<int>`: it loads the product with `productId == <int>`
* `dla://Profile`: it loads the profile tab

## Caveats:

1. The code is pretty Raw. I had a little time to create this POC, therefore the code is raw and could be greatly improved.
2. When using the `NavigationLink` with the `tag:selection:` constructor within a `List`, the cell with the right `tag` must be loaded in order to consume the DeepLink properly. For example, if we open the app with `dla://Products?id=30` the product description won't be loaded immediately because when loaded, we will only see products from `0` to `13` (more or less) and a few other cells are preloaded, but the app is not aware of a cell with that id. We need to scroll until the cell is loaded to actually navigate. There are ways to overcome this (different parsing logic, different product loading logic, scrolling to the estimated position of the list, ...) but they are out of the scope of this POC.
