import React, {forwardRef, useMemo, useRef} from 'react';
import {getImageUri, getProcessedColors} from '../../utils';
import {YamapProps, YamapRef} from './types';
import {
  onCameraPositionReceived,
  onScreenToWorldPointsReceived,
  onVisibleRegionReceived,
  onWorldToScreenPointsReceived,
} from './events';
import {useYamap} from '../../hooks/useYamap';
import {YamapNativeComponent, YamapNativeRef} from './YamapNativeComponent';

export const Yamap = forwardRef<YamapRef, YamapProps>(({
    showUserPosition = true,
    ...props
  }, ref) => {

  const nativeRef = useRef<YamapNativeRef | null>(null);

  useYamap(nativeRef, ref, 'YamapView');

  const nativeProps = useMemo(() =>
      getProcessedColors({
        ...props,
        onCameraPositionReceived,
        onVisibleRegionReceived,
        onWorldToScreenPointsReceived,
        onScreenToWorldPointsReceived,
        showUserPosition,
        userLocationIcon: getImageUri(props.userLocationIcon),
      }, ['userLocationAccuracyFillColor', 'userLocationAccuracyStrokeColor']),
    [props, showUserPosition]
  );

  return (
    <YamapNativeComponent
      {...nativeProps}
      ref={nativeRef}
    />
  );
});
