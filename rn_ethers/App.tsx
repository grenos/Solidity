import React, {useEffect, useState} from 'react';
import {SafeAreaView, StatusBar, useColorScheme, Text} from 'react-native';

// Import the crypto getRandomValues shim (**BEFORE** the shims)
import 'react-native-get-random-values';
// Import the the ethers shims (**BEFORE** ethers)
import '@ethersproject/shims';
// Import the ethers library
import {ethers} from 'ethers';

import * as Keychain from 'react-native-keychain';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const [provider, setProvider] = useState<ethers.providers.InfuraProvider>();
  const [address, setAddress] = useState<String>();

  useEffect(() => {
    const providerInstance = new ethers.providers.InfuraProvider('ropsten', {
      projectId: process.env.INFURA_PROJECT_ID,
      projectSecret: process.env.INFURA_PRJECT_SECRET,
    });
    const walletInstance = ethers.Wallet.createRandom();

    // console.log(walletInstance.privateKey);
    // console.log(walletInstance.address);
    // console.log(walletInstance.mnemonic);

    setPrivateKeyToKeychain(
      walletInstance.address,
      walletInstance.privateKey.substring(2),
    );

    setAddress(walletInstance.address);
    setProvider(providerInstance);
  }, []);

  const setPrivateKeyToKeychain = async (
    username: string,
    password: string,
  ) => {
    const result = await Keychain.setGenericPassword(username, password);
    console.log(result);
  };

  const getPrivateKeyFromKeychain = async () => {
    try {
      const credentials = await Keychain.getGenericPassword();
      if (credentials) {
        console.log(
          'Credentials successfully loaded for user ' + credentials.username,
        );
      } else {
        console.log('No credentials stored');
      }
    } catch (error) {
      console.log("Keychain couldn't be accessed!", error);
    }
  };

  return (
    <SafeAreaView>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <Text style={{padding: 100}} onPress={getPrivateKeyFromKeychain}>
        Press ME please!
      </Text>
    </SafeAreaView>
  );
};

export default App;
