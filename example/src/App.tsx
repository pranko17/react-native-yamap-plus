import React, {useState} from 'react';
import {YamapInstance} from './../../';
import {SelectOption} from './components/SelectOption';

import {API_KEY} from './config';
import {MapScreen} from './screens/MapScreen';
import {Screen} from './screens/screens';
import {ClusteredMapScreen} from './screens/ClusteredMapScreen';
YamapInstance.setLocale('ru_RU').then(() => {console.log('setLocale');}).catch(console.warn);
YamapInstance.init(API_KEY).then(() => {console.log('init');}).catch(console.warn);

export default function App() {
  const [selectedScreen, setSelectedScreen] = useState(Screen.Map);

  return (
    <>
      <SelectOption selectedScreen={selectedScreen} setSelectedScreen={setSelectedScreen} />
      {selectedScreen === Screen.Map && <MapScreen />}
      {selectedScreen === Screen.ClusteredMap && <ClusteredMapScreen />}
    </>
  );
}

