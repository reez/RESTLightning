@testable import RESTLightningFramework
import PlaygroundSupport

Current = .mock

let bundle = Bundle(for: ViewNodeViewController.self)
let storyboard = UIStoryboard(name: "ViewNodeViewController", bundle: bundle)
let vc = storyboard.instantiateViewController(withIdentifier: "ViewNodeViewController")
let parent = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = parent

