//
//  AddNodeViewController.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

import UIKit

public class AddNodeViewController: UIViewController {
    
    var remoteRESTConfiguration = RemoteRESTConfiguration(certificate: nil, macaroon: nil, url: nil)
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
//    let rootStackView = UIStackView()
//    let titleLabel = UILabel()
//    let macaroonStackView = UIStackView()
//    let certificateStackView = UIStackView()
//    let uriStackView = UIStackView()
//    let macaroonLabel = UILabel()
//    let certificateLabel = UILabel()
//    let uriLabel = UILabel()
//    let macaroonTextField = UITextField()
//    let certificateTextField = UITextField()
//    let uriTextField = UITextField()
//    let submitButton = UIButton()
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var certificateLabel: UILabel!
    @IBOutlet var certificateTextField: UITextField!
    
    @IBOutlet var macaroonLabel: UILabel!
    @IBOutlet var macaroonTextField: UITextField!
    
    @IBOutlet var uriLabel: UILabel!
    @IBOutlet var uriTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        macaroonTextField.delegate = self
        certificateTextField.delegate = self
        uriTextField.delegate = self
        
        setupView()
    }
    
    @objc func submitButtonPressed() {
        activityIndicator.startAnimating()
        
        if let certificate = certificateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let macaroon = macaroonTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let url = uriTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            remoteRESTConfiguration = RemoteRESTConfiguration(certificate: certificate, macaroon: macaroon, url: URL(string: url))
            
            let resultSavedPost = Current.lightningPosted.postSaved(remoteRESTConfiguration)
            switch resultSavedPost {
            case .success(_):
                self.activityIndicator.stopAnimating()
                let bundle = Bundle(for: ViewNodeViewController.self)
                let storyboard = UIStoryboard(name: "ViewNodeViewController", bundle: bundle)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewNodeViewController") as! ViewNodeViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case let .failure(error):
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(
                    title: "Something went wrong adding node",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Something went wrong in adding node",
                    message: DataError.remoteNodeInfoMissing.localizedDescription,
                    preferredStyle: .alert
                )
                self.present(alert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }


}

extension AddNodeViewController: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let completion = urlSessionChallenge(for: remoteRESTConfiguration, with: challenge)
        completionHandler(completion.0, completion.1)
    }
}

extension AddNodeViewController:  UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitButtonPressed()
        return true
    }
}

extension AddNodeViewController {
    public func setupView() {
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.titleLabel.text = "Add Node"
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: self.traitCollection)
        self.titleLabel.textColor = UIColor.init(white: 0.2, alpha: 1)
        
        self.certificateLabel.text = "Cert"
        self.certificateLabel.font = UIFont.preferredFont(forTextStyle: .caption1, compatibleWith: self.traitCollection)
        self.certificateTextField.borderStyle = .roundedRect
        
        self.macaroonLabel.text = "Macaroon"
        self.macaroonLabel.font = UIFont.preferredFont(forTextStyle: .caption1, compatibleWith: self.traitCollection)
        self.macaroonTextField.borderStyle = .roundedRect
        
        self.uriLabel.text = "IP URL"
        self.uriLabel.font = UIFont.preferredFont(forTextStyle: .caption1, compatibleWith: self.traitCollection)
        self.uriTextField.borderStyle = .roundedRect
        
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout, compatibleWith: self.traitCollection)
        self.submitButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .highlighted)
        self.submitButton.backgroundColor = .blue
        self.submitButton.layer.cornerRadius = 6
        self.submitButton.layer.masksToBounds = true
        submitButton.addTarget(self, action: #selector(AddNodeViewController.submitButtonPressed), for: .touchUpInside)

    }
    
}
