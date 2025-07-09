import React, {useEffect, useRef, useState} from 'react';
import {Platform, StyleSheet} from 'react-native';
import {Yamap, Circle, Marker, MarkerRef, Polyline, YamapRef} from '../../../';
import {Polygon} from '../../../src';

export const MapScreen = () => {
  const [mapLoaded, setMapLoaded] = useState(false);
  const mapRef = useRef<YamapRef | null>(null);
  const markerRef = useRef<MarkerRef | null>(null);
  const angleRef = useRef(0);

    useEffect(() => {
      if (mapLoaded) {
        mapRef.current?.getCameraPosition(e => {
          console.log('getCameraPosition', e);
        });
        mapRef.current?.getVisibleRegion(e => {
          console.log('getVisibleRegion', e);
        });
        mapRef.current?.getWorldPoints([{x: 100, y: 100}], e => {
          console.log('getWorldPoints', e);
        });
        mapRef.current?.getScreenPoints([{lat: 55.75124399961543, lon: 37.618422999999986}], e => {
          console.log('getScreenPoints', e);
        });
      }
    }, [mapLoaded]);

  return (
    <Yamap
      ref={mapRef}
      initialRegion={{lat: 55.751244, lon: 37.618423, zoom: 12}}
      style={styles.container}
      logoPosition={{horizontal: 'right', vertical: 'top'}}
      onMapLoaded={(e) => {
        console.log('onMapLoaded', e.nativeEvent);
        setMapLoaded(true);
      }}
      onCameraPositionChange={e => {
          console.log('onCameraPositionChange', e.nativeEvent);
      }}
      onCameraPositionChangeEnd={e => {
          console.log('onCameraPositionChangeEnd', e.nativeEvent);
      }}
      onMapPress={e => {
        console.log('map onPress', e.nativeEvent);
        markerRef.current?.animatedMoveTo(e.nativeEvent, 500);
      }}
      onMapLongPress={(e) => {
        console.log('map onLongPress', e.nativeEvent);
      }}
    >
      <Marker
        ref={markerRef}
        point={{lat: 55.751244, lon: 37.618423}}
        source={require('../assets/images/marker.png')}
        scale={0.25}
        visible={Platform.OS === 'android' ? mapLoaded : true}
        rotated={true}
        onPress={() => {
           console.log('marker onPress');
        }}
        anchor={{x: 0.5, y: 1}}
      />
      <Circle
        center={{lat: 55.74, lon: 37.65}}
        radius={500}
        strokeWidth={5}
        strokeColor={'red'}
        fillColor={'blue'}
        onPress={() => {
          console.log('circle onPress');
          angleRef.current = angleRef.current + 180;
          markerRef.current?.animatedRotateTo(angleRef.current, 300);
        }}
      />
      <Polygon
        points={[
          {lat: 55.74, lon: 37.57},
          {lat: 55.7, lon: 37.6},
          {lat: 55.72, lon: 37.64},
          {lat: 55.77, lon: 37.64},
        ]}
        fillColor={'green'}
        strokeWidth={0}
        handled={false}
        onPress={() => {
          console.log('polygon press');
        }}
      />
      <Polyline
        points={[
          {lat: 55.78, lon: 37.6},
          {lat: 55.76, lon: 37.57},
          {lat: 55.78, lon: 37.64},
          {lat: 55.79, lon: 37.6},
        ]}
        strokeWidth={4}
        strokeColor={'black'}
        outlineColor={'orange'}
        outlineWidth={2}
        handled={false}
        gapLength={5}
        dashLength={20}
        onPress={() => {
          console.log('polyline press');
        }}
      />
    </Yamap>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
