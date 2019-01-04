//
//  Environment.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

import Foundation


// =======================================
//
//             Environment
//
// =======================================

struct Environment {
    var date: () -> Date = Date.init
    var lightningNode = LightningNode()
    var restConfig: RemoteRESTConfiguration?
    var lightningSaved = LightningFetched()
    var lightningPosted = LightningPosted()
}

var Current = Environment()

// =======================================
//
//            Dependency Mocks
//
// =======================================

extension Date {
    static let mock = Date()
}

extension RemoteRESTConfiguration {
    static let mock = RemoteRESTConfiguration.init(certificate: "Mock 2 Certificate", macaroon: "Mock 2 Macaroon", url: URL(string: "mock2URLString"))
}

extension LightningNode.Info {
    static let mock = LightningNode.Info(
        alias: "LightningNode.Info mock alias",
        best_header_timestamp: "LightningNode.Info mock timestamp",
        block_hash: "LightningNode.Info mock hash",
        block_height: 0,
        chains: [Chains.bitcoin],
        identity_pubkey: "LightningNode.Info mock pubkey",
        num_active_channels: 0,
        num_peers: 0,
        synced_to_chain: false,
        testnet: true,
        version: "LightningNode.Info mock version")
}

extension LightningFetched {
    static let mock = LightningFetched(fetchSaved: {
        let remoteRESTConfiguration =  RemoteRESTConfiguration.mock
        return ResultSavedGet.success(remoteRESTConfiguration)
    })
}

extension LightningPosted {
    static let mock = LightningPosted { (rRC) -> ResultSavedPost<String, Error> in
        return ResultSavedPost.success("Success!")
    }
}

extension LightningNode {
    static let mock = LightningNode(
        fetchInfo: { (_, _, callback)  in
            callback(
                .success(.mock)
            )
    }, postInvoice: { (_, _, _, callback)  in
        callback(
            .success(.mock)
        )
    },
       fetchPayReq: { (_, _, _, callback)  in
        callback(
            .success(.mock)
        )
    }
    )
}

extension InvoiceResponse {
    static let mock = InvoiceResponse.init(add_index: "fake add index", payment_request: "fake payment request", r_hash: "fake r hash")
}

extension InvoiceRequest {
    static let mock = InvoiceRequest.init(memo: "fake memo", value: "46")
}

extension PayResponse {
    static let mock = PayResponse.init(num_satoshis: "22", description: "fake description")
}

extension Environment {
    static let mock = Environment(
        date: { .mock },
        lightningNode: .mock,
        restConfig: .mock,
        lightningSaved: .mock,
        lightningPosted: .mock
    )
}

//Current = .mock
