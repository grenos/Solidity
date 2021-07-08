import React, {useEffect, useState} from 'react';
import {
  SafeAreaView,
  StatusBar,
  useColorScheme,
  Text,
  TextInput,
} from 'react-native';

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
  const [address, setAddress] = useState<String>('');
  const [biometryType, setBiometryType] = useState<String | null>('');
  const [email, setEmail] = useState('');

  useEffect(() => {
    Keychain.getSupportedBiometryType({}).then(bio => {
      setBiometryType(bio);
    });
  }, []);

  useEffect(() => {
    const providerInstance = new ethers.providers.InfuraProvider('ropsten', {
      projectId: process.env.INFURA_PROJECT_ID,
      projectSecret: process.env.INFURA_PRJECT_SECRET,
    });
    const walletInstance = ethers.Wallet.createRandom();

    // show to user once
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
    const options = {
      accessControl:
        Keychain.ACCESS_CONTROL.BIOMETRY_CURRENT_SET_OR_DEVICE_PASSCODE,
      accessible: Keychain.ACCESSIBLE.WHEN_UNLOCKED_THIS_DEVICE_ONLY,
    };
    const result = await Keychain.setGenericPassword(
      username,
      password,
      options,
    );
    console.log(result);
  };

  const getPrivateKeyFromKeychain = async () => {
    const oprions = {
      authenticationPrompt: {
        title: 'Title',
        subtitle: 'Subtitle - Android Only',
        description: 'Description - Android Only',
        cancel: 'Cancel - - Android Only',
      },
      accessControl:
        Keychain.ACCESS_CONTROL.BIOMETRY_CURRENT_SET_OR_DEVICE_PASSCODE,
    };

    try {
      const credentials = await Keychain.getGenericPassword(oprions);
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
      <TextInput
        placeholder="email"
        onChangeText={setEmail}
        value={email}
        keyboardType="email-address"
      />
    </SafeAreaView>
  );
};

export default App;
