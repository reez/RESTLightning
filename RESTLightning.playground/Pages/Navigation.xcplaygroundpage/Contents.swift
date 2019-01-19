@testable import RESTLightningFramework
import PlaygroundSupport

Current = .mock

let bundle = Bundle(for: NavigationViewController.self)
let storyboard = UIStoryboard(name: "NavigationViewController", bundle: bundle)
let vc = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
let navVC = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = navVC
