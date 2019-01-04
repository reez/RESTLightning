@testable import RESTLightningFramework
import PlaygroundSupport

Current = .mock
//     return ResultSavedPost.failure(DataError.remoteNodeInfoMissing)

let bundle = Bundle(for: AddNodeViewController.self)
let storyboard = UIStoryboard(name: "AddNodeViewController", bundle: bundle)
let vc = storyboard.instantiateViewController(withIdentifier: "AddNodeViewController")
let addVC = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = addVC
