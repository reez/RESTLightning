//
//  FreeFunctions.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

// =======================================
//
//          API Free Functions
//
// =======================================
import Foundation

func dataTaskPost<T: Decodable>(invoiceRequest: InvoiceRequest, path: String, configuration: RemoteRESTConfiguration?, sessionDelegate: URLSessionDelegate, completionHandler: (@escaping (Result<T, Error>) -> Void)) {
    guard let url = configuration?.url else {
        completionHandler(Result.failure(DataError.badURL))
        return
    }
    
    let fullURL = URL(string: "https://" + url.absoluteString + path)!
    var request = URLRequest(url: fullURL)
    request.setValue(configuration?.macaroon, forHTTPHeaderField: "Grpc-Metadata-macaroon")
    request.httpMethod = "POST"
    
    let postData = invoiceRequest
    guard let data = try? JSONEncoder().encode(postData) else { return }
    request.httpBody = data
    
    let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
    
    let task = session.dataTask(with: request) { data, urlResponse, error in
        do {
            if let error = error {
                throw error
            } else if let data = data {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) // .mutableContainers
                print("Resp: \(jsonResponse)")
                let decoder = JSONDecoder()
                completionHandler(.success(try decoder.decode(T.self, from: data)))
            } else {
                fatalError()
            }
        } catch let finalError {
            completionHandler(.failure(finalError))
        }
    }
    task.resume()
}

func postInvoice(invoiceRequest: InvoiceRequest, sess: URLSessionDelegate, remoteRESTConfiguration: RemoteRESTConfiguration?, onComplete completionHandler: (@escaping (Result<InvoiceResponse, Error>) -> Void)) {
    dataTaskPost(invoiceRequest: invoiceRequest, path: "/v1/invoices", configuration: remoteRESTConfiguration, sessionDelegate: sess, completionHandler: completionHandler)
}

func dataTask<T: Decodable>(path: String, configuration: RemoteRESTConfiguration?, sessionDelegate: URLSessionDelegate, completionHandler: (@escaping (Result<T, Error>) -> Void)) {
    guard let url = configuration?.url else {
        completionHandler(Result.failure(DataError.badURL))
        return
    }
    let fullURL = URL(string: "https://" + url.absoluteString + path)!
    var request = URLRequest(url: fullURL)
    
    request.setValue(configuration?.macaroon, forHTTPHeaderField: "Grpc-Metadata-macaroon")
    request.httpMethod = "GET"
    let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
    
    let task = session.dataTask(with: request) { data, urlResponse, error in
        do {
            if let error = error {
                throw error
            } else if let data = data {
                let decoder = JSONDecoder()
                completionHandler(.success(try decoder.decode(T.self, from: data)))
            } else {
                fatalError()
            }
        } catch let finalError {
            completionHandler(.failure(finalError))
        }
    }
    task.resume()
}

func fetchInfo(sess: URLSessionDelegate, remoteRESTConfiguration: RemoteRESTConfiguration?, onComplete completionHandler: (@escaping (Result<LightningNode.Info, Error>) -> Void)) {
    dataTask(path: "/v1/getinfo", configuration: remoteRESTConfiguration, sessionDelegate: sess, completionHandler: completionHandler)
}

func dataTaskRequest<T: Decodable>(path: String, configuration: RemoteRESTConfiguration?, sessionDelegate: URLSessionDelegate, completionHandler: (@escaping (Result<T, Error>) -> Void)) {
    guard let url = configuration?.url else {
        completionHandler(Result.failure(DataError.badURL))
        return
    }
    let fullURL = URL(string: "https://" + url.absoluteString + path)!
    var request = URLRequest(url: fullURL)
    
    request.setValue(configuration?.macaroon, forHTTPHeaderField: "Grpc-Metadata-macaroon")
    request.httpMethod = "GET"
    let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)
    
    let task = session.dataTask(with: request) { data, urlResponse, error in
        do {
            if let error = error {
                throw error
            } else if let data = data {
                let decoder = JSONDecoder()
                completionHandler(.success(try decoder.decode(T.self, from: data)))
            } else {
                fatalError()
            }
        } catch let finalError {
            completionHandler(.failure(finalError))
        }
    }
    task.resume()
}

func fetchPayReq(payreq: String, sess: URLSessionDelegate, remoteRESTConfiguration: RemoteRESTConfiguration?, onComplete completionHandler: (@escaping (Result<PayResponse, Error>) -> Void)) {
    dataTaskRequest(path: "/v1/payreq/\(payreq)", configuration: remoteRESTConfiguration, sessionDelegate: sess, completionHandler: completionHandler)
}

public func urlSessionChallenge(for remoteRESTConfiguration: RemoteRESTConfiguration, with challenge: URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?)  {
    if let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 {
        if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
            let data = SecCertificateCopyData(certificate) as Data
            if data.base64EncodedString() == remoteRESTConfiguration.certificate {
                let comp: (URLSession.AuthChallengeDisposition, URLCredential?) = (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: trust))
                return comp
            } else {
                print("\(DataError.certsNotEqual.localizedDescription)")
                let comp: (URLSession.AuthChallengeDisposition, URLCredential?) = (URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
                return comp
            }
        } else {
            print(DataError.noIndex.localizedDescription)
            let comp: (URLSession.AuthChallengeDisposition, URLCredential?) = (URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            return comp
        }
    } else {
        print(DataError.noIndex.localizedDescription)
        let comp: (URLSession.AuthChallengeDisposition, URLCredential?) = (URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        return comp
    }
}


// =======================================
//
//          Save Free Functions
//
// =======================================


public func fetchSavedValue() -> ResultSavedGet<RemoteRESTConfiguration, Error> {
    guard let getData = UserDefaults.standard.object(forKey: "Remote") as? Data else { return ResultSavedGet.failure(DataError.noData)}
    guard let remoteRESTConfiguration = try? JSONDecoder().decode(RemoteRESTConfiguration.self, from: getData) else { return ResultSavedGet.failure(DataError.noRemoteData) }
    return ResultSavedGet<RemoteRESTConfiguration, Error>.success(remoteRESTConfiguration)
}

public func postSaveValue(config: RemoteRESTConfiguration) -> ResultSavedPost<String, Error> {
    guard let data = try? JSONEncoder().encode(config) else { return ResultSavedPost.failure(DataError.encodingFailure) }
    UserDefaults.standard.set(data, forKey: "Remote")
    return ResultSavedPost.success("Saved Value to Defaults!")
}
