//
//  ContentView.swift
//  rsvp_staking
//
//  Created by Vasileios  Gkreen on 07/07/21.
//

import SwiftUI
import web3swift


struct ContentView: View {
	
	@State private var address = ""
	@State private var privateKey = ""
	@State private var password = ""
	@State private var email = ""
	@State private var wallet: Wallet = Wallet(address: "", data: Data(), name: "", isHD: false)
//	@State var keystoreManager: KeystoreManager?
	
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
	
	func createWallet() {
		let password = password
		let keystore = try! EthereumKeystoreV3(password: password)!
		let name = email
		let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
		let address = keystore.addresses!.first!.address
		wallet = Wallet(address: address, data: keyData, name: name, isHD: false)
	}
	
//	func getPrivateKey() {
//		let password = password
//		let ethereumAddress = EthereumAddress(wallet.address)!
//		privateKey = try! keystoreManager?.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress).toHexString()
//	}
	
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//		ContentView(keystoreManager: KeystoreManager(["EthereumKeystoreV3"]))
//    }
//}
