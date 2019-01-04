//
//  ViewModel.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

// =======================================
//
//          View Model
//
// =======================================
import Foundation

class LightningViewModel {
    
    var lightningNodeInfo: LightningNode.Info = LightningNode.Info.init(
        alias: "No Alias",
        best_header_timestamp: "",
        block_hash: "No Block Hash",
        block_height: 0,
        chains: [Chains.bitcoin],
        identity_pubkey: "No Identity Pubkey",
        num_active_channels: 0,
        num_peers: 0,
        synced_to_chain: false,
        testnet: true,
        version: "No Version #") {
        didSet {
            callback(lightningNodeInfo)
        }
    }
    var callback: ((LightningNode.Info) -> Void)
    
    init(callback: @escaping (LightningNode.Info) -> Void) {
        self.callback = callback
        self.callback(lightningNodeInfo)
    }
    
}
