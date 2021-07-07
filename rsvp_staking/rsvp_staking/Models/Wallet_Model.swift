//
//  Wallet_Model.swift
//  rsvp_staking
//
//  Created by Vasileios  Gkreen on 07/07/21.
//

import Foundation


struct Wallet {
	let address: String
	let data: Data
	let name: String
	let isHD: Bool
}

struct HDKey {
	let name: String?
	let address: String
}
