//
//  ViewNodeViewController.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

import UIKit

public class ViewNodeViewController: UIViewController {

    private var viewModel: LightningViewModel!
    private var remoteRESTConfiguration = RemoteRESTConfiguration.init(certificate: nil, macaroon: nil, url: nil)
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    @IBOutlet var infoLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LightningViewModel { [weak self] lightning in
            DispatchQueue.main.async {
                
                let text = """
                Timestamp: \(lightning.best_header_timestamp.timeInterval())
                Block hash: \(lightning.block_hash)
                Block height: \(lightning.block_height)
                Chain: \(lightning.chains[0].rawValue)
                Pubkey: \(lightning.identity_pubkey)
                Channels: \(lightning.num_active_channels)
                Peers: \(lightning.num_peers)
                """
                
                self?.infoLabel.text = text
            }
        }
        
        let resultSavedGet = Current.lightningSaved.fetchSaved()
        switch resultSavedGet {
        case let .success(savedConfig):
            remoteRESTConfiguration = savedConfig
            Current.lightningNode.fetchInfo(self, savedConfig) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(lightningNodeInfo):
                        self?.viewModel.lightningNodeInfo = lightningNodeInfo
                    case let .failure(error):
                        let alert = UIAlertController(
                            title: DataError.fetchInfoFailure.localizedDescription,
                            message: error.localizedDescription,
                            preferredStyle: .alert
                        )
                        self?.present(alert, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        case .failure(_):
            let alert = UIAlertController(
                title: DataError.fetchInfoFailure.localizedDescription,
                message: "Didn't get saved data",
                preferredStyle: .alert
            )
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}

extension ViewNodeViewController:  URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let completion = urlSessionChallenge(for: remoteRESTConfiguration, with: challenge)
        completionHandler(completion.0, completion.1)
    }
}
