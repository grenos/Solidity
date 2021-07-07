import React, {useEffect, useState} from 'react';
import {SafeAreaView, StatusBar, useColorScheme, Text} from 'react-native';

// Import the crypto getRandomValues shim (**BEFORE** the shims)
import 'react-native-get-random-values';
// Import the the ethers shims (**BEFORE** ethers)
import '@ethersproject/shims';
// Import the ethers library
import {ethers} from 'ethers';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const [provider, setProvider] = useState<ethers.providers.InfuraProvider>();
  const [wallet, setWallet] = useState<ethers.Wallet>();

  useEffect(() => {
    const providerInstance = new ethers.providers.InfuraProvider('ropsten', {
      projectId: process.env.INFURA_PROJECT_ID,
      projectSecret: process.env.INFURA_PRJECT_SECRET,
    });
    const walletInstance = ethers.Wallet.createRandom();

    // console.log(walletInstance.privateKey);
    // console.log(walletInstance.address);
    console.log(walletInstance.mnemonic);

    setWallet(walletInstance);
    setProvider(providerInstance);
  }, []);

  return (
    <SafeAreaView>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <Text>TEST PAGE</Text>
    </SafeAreaView>
  );
};

export default App;
