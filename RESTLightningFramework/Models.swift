//
//  Models.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

// =======================================
//
//             Models
//
// =======================================
import Foundation

public enum DataError: Error {
    case badURL
    case remoteNodeInfoMissing
    case fetchInfoFailure
    case certsNotEqual
    case noIndex
    case wrongCertsNoIndex
    case noData
    case noRemoteData
    case encodingFailure
}

extension DataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("The URL is not working", comment: "Bad URL")
        case .remoteNodeInfoMissing:
            return NSLocalizedString("Cert/Mac/URI incorrect", comment: "Incorrect Remote Info")
        case .fetchInfoFailure:
            return NSLocalizedString("Recieved failure when fetching data", comment: "Data Request Failure")
        case .certsNotEqual:
            return NSLocalizedString("Certs on client and server are not equal", comment: "Certs not matching")
        case .noIndex:
            return NSLocalizedString("Couldn't get a certificate at index", comment: "No index 0")
        case .wrongCertsNoIndex:
            return NSLocalizedString("No server trust and/or count above 0", comment: "Server trust failed")
        case .noData:
            return NSLocalizedString("noData", comment: "noData")
        case .noRemoteData:
            return NSLocalizedString("noRemoteData", comment: "noRemoteData")
        case .encodingFailure:
            return NSLocalizedString("encodingFailure", comment: "encodingFailure")
        }
    }
}

enum Result<Value, Error> {
    case success(Value)
    case failure(Error)
}

public struct RemoteRESTConfiguration: Codable {
    public let certificate: String?
    public let macaroon: String?
    public let url: URL?
}

enum Chains: String, Codable {
    case bitcoin
    case litecoin
}

struct LightningNode {
    struct Info: Decodable {
        let alias: String
        let best_header_timestamp: String
        let block_hash: String
        let block_height: Int
        let chains: [Chains]
        let identity_pubkey: String
        let num_active_channels: Int
        let num_peers: Int
        let synced_to_chain: Bool
        let testnet: Bool
        let version: String
    }
    
    var fetchInfo = fetchInfo(sess: remoteRESTConfiguration: onComplete:)
    var postInvoice = postInvoice(invoiceRequest: sess: remoteRESTConfiguration: onComplete:)
    var fetchPayReq = fetchPayReq(payreq: sess: remoteRESTConfiguration: onComplete:)
}

struct PayRequest: Encodable {
    let pay_req: String
}

struct PayResponse: Decodable {
    let num_satoshis: String
    let description: String
}



struct InvoiceRequest: Codable {
    let memo: String
    let value: String
}

struct InvoiceResponse: Decodable {
    let add_index: String
    let payment_request: String
    let r_hash: String
}

public enum ResultSavedPost<Value, Error> {
    case success(String)
    case failure(Error)
}

public enum ResultSavedGet<Value, Error> {
    case success(Value)
    case failure(Error)
}

public struct LightningFetched {
    var fetchSaved = fetchSavedValue
}

public struct LightningPosted {
    var postSaved = postSaveValue(config:)
}

public enum ResultPost<Value, Error> {
    case success(String)
    case failure(Error)
}
