//
//  NetworkMonitor.swift
//  TeamHubAdvanced
//
//  Created by Ayush yadav on 19/03/26.
//

import Foundation

protocol NetworkMonitor {
    var isConnected: Bool { get }
}

final class DefaultNetworkMonitor: NetworkMonitor {
    var isConnected: Bool {
        true // for now (later real)
    }
}
