#import <React/RCTViewManager.h>
#import <MapKit/MapKit.h>
#import <math.h>
#import "Converter/RCTConvert+Yamap.m"
#import "ClusteredYamapView.h"
#import "RNYamap.h"
#import "View/RNCYMView.h"

#ifndef MAX
#import <NSObjCRuntime.h>
#endif

@implementation ClusteredYamapView

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"onCameraPositionReceived",
        @"onVisibleRegionReceived",
        @"onCameraPositionChange",
        @"onMapPress",
        @"onMapLongPress",
        @"onCameraPositionChangeEnd",
        @"onMapLoaded",
        @"onWorldToScreenPointsReceived",
        @"onScreenToWorldPointsReceived"
    ];
}

- (instancetype)init {
    self = [super init];
    return self;
}
+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (UIView *_Nullable)view {
    RNCYMView* map = [[RNCYMView alloc] init];
    return map;
}

- (void)setCenterForMap:(RNCYMView*)map center:(NSDictionary*)_center zoom:(float)zoom azimuth:(float)azimuth tilt:(float)tilt duration:(float)duration animation:(int)animation {
    YMKPoint *center = [RCTConvert YMKPoint:_center];
    YMKCameraPosition *pos = [YMKCameraPosition cameraPositionWithTarget:center zoom:zoom azimuth:azimuth tilt:tilt];
    [map setCenter:pos withDuration:duration withAnimation:animation];
}

// props
RCT_EXPORT_VIEW_PROPERTY(onCameraPositionReceived, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVisibleRegionReceived, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCameraPositionChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMapPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMapLongPress, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCameraPositionChangeEnd, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onMapLoaded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onWorldToScreenPointsReceived, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onScreenToWorldPointsReceived, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(initialRegion, NSDictionary, RNYMView) {
    if (json && view) {
        [view setInitialRegion:json];
    }
}
RCT_CUSTOM_VIEW_PROPERTY(userLocationAccuracyFillColor, NSNumber, RNCYMView) {
    [view setUserLocationAccuracyFillColor:[RCTConvert UIColor:json]];
}

RCT_CUSTOM_VIEW_PROPERTY(clusterColor, NSNumber, RNCYMView) {
    [view setClusterColor:[RCTConvert UIColor:json]];
}

RCT_CUSTOM_VIEW_PROPERTY(clusteredMarkers, NSArray<YMKRequestPoint*>*_Nonnull, RNCYMView) {
    [view setClusteredMarkers:[RCTConvert NSArray:json]];
}

RCT_CUSTOM_VIEW_PROPERTY(userLocationAccuracyStrokeColor, NSNumber, RNCYMView) {
    [view setUserLocationAccuracyStrokeColor:[RCTConvert UIColor:json]];
}


RCT_CUSTOM_VIEW_PROPERTY(userLocationAccuracyStrokeWidth, NSNumber, RNCYMView) {
    [view setUserLocationAccuracyStrokeWidth:[json floatValue]];
}

RCT_CUSTOM_VIEW_PROPERTY(userLocationIcon, NSString, RNCYMView) {
    if (json && view) {
        [view setUserLocationIcon:json];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(userLocationIconScale, NSNumber, RNCYMView) {
    if (json && view) {
        [view setUserLocationIconScale:json];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(showUserPosition, BOOL, RNCYMView) {
    if (view) {
        [view setListenUserLocation: json ? [json boolValue] : NO];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(followUser, BOOL, RNCYMView) {
    [view setFollowUser: json ? [json boolValue] : NO];
}

RCT_CUSTOM_VIEW_PROPERTY(nightMode, BOOL, RNCYMView) {
    if (view) {
        [view setNightMode: json ? [json boolValue]: NO];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(mapStyle, NSString, RNCYMView) {
    if (json && view) {
        [view.mapWindow.map setMapStyleWithStyle:json];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(zoomGesturesEnabled, BOOL, RNCYMView) {
    if (view) {
        view.mapWindow.map.zoomGesturesEnabled = json ? [json boolValue] : YES;
    }
}

RCT_CUSTOM_VIEW_PROPERTY(scrollGesturesEnabled, BOOL, RNCYMView) {
    if (view) {
        view.mapWindow.map.scrollGesturesEnabled = json ? [json boolValue] : YES;
    }
}

RCT_CUSTOM_VIEW_PROPERTY(tiltGesturesEnabled, BOOL, RNCYMView) {
    if (view) {
        view.mapWindow.map.tiltGesturesEnabled = json ? [json boolValue] : YES;
    }
}

RCT_CUSTOM_VIEW_PROPERTY(rotateGesturesEnabled, BOOL, RNCYMView) {
    if (view) {
        view.mapWindow.map.rotateGesturesEnabled = json ? [json boolValue] : YES;
    }
}

RCT_CUSTOM_VIEW_PROPERTY(fastTapEnabled, BOOL, RNCYMView) {
    if (view) {
        view.mapWindow.map.fastTapEnabled = json ? [json boolValue] : YES;
    }
}

RCT_CUSTOM_VIEW_PROPERTY(mapType, NSString, RNCYMView) {
    if (view) {
        [view setMapType:json];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(interactive, BOOL, RNYMView) {
    if (json && view) {
        [view setInteractive:[json boolValue]];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(logoPosition, BOOL, RNYMView) {
    if (json && view) {
        [view setLogoPosition:json];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(logoPadding, BOOL, RNYMView) {
    if (json && view) {
        [view setLogoPadding:json];
    }
}


RCT_CUSTOM_VIEW_PROPERTY(clusterIcon, NSString, RNCYMView) {
  if (json && view) {
        [view setClusterIcon:json];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(clusterSize, BOOL, RNCYMView) {
    if (json && view) {
        [view setClusterSize:json];
    }
}

RCT_CUSTOM_VIEW_PROPERTY(clusterTextColor, NSNumber, RNCYMView) {
    [view setClusterTextColor:[RCTConvert UIColor:json]];
}

RCT_CUSTOM_VIEW_PROPERTY(clusterTextSize, NSNumber, RNCYMView) {
    [view setClusterTextSize:json ? [json floatValue] : 0.0];
}

RCT_CUSTOM_VIEW_PROPERTY(clusterTextXOffset, NSNumber, RNCYMView) {
    [view setClusterTextXOffset:json ? [json floatValue] : 0.0];
}

RCT_CUSTOM_VIEW_PROPERTY(clusterTextYOffset, NSNumber, RNCYMView) {
    [view setClusterTextYOffset:json ? [json floatValue] : 0.0];
}

// ref
RCT_EXPORT_METHOD(fitAllMarkers:(nonnull NSNumber*) reactTag duration: (NSNumber*_Nonnull) duration animation:(NSNumber*_Nonnull) animation) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNCYMView *view = (RNCYMView*) viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNCYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }
      [view fitAllMarkers: [duration floatValue] withAnimation:[animation intValue]];
    }];
}

RCT_EXPORT_METHOD(fitMarkers:(nonnull NSNumber *)reactTag json:(id)json duration: (NSNumber*_Nonnull) duration animation:(NSNumber*_Nonnull) animation) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView*> *viewRegistry) {
        RNYMView *view = (RNYMView *)viewRegistry[reactTag];

        if (!view || ![view isKindOfClass:[RNYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }

        NSArray<YMKPoint *> *points = [RCTConvert Points:json];
        [view fitMarkers: points withDuration: [duration floatValue] withAnimation: [animation intValue]];
    }];
}

RCT_EXPORT_METHOD(setCenter:(nonnull NSNumber*) reactTag center:(NSDictionary*_Nonnull) center zoom:(NSNumber*_Nonnull) zoom azimuth:(NSNumber*_Nonnull) azimuth tilt:(NSNumber*_Nonnull) tilt duration: (NSNumber*_Nonnull) duration animation:(NSNumber*_Nonnull) animation) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNCYMView *view = (RNCYMView*) viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNCYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }
        [self setCenterForMap: view center:center zoom: [zoom floatValue] azimuth: [azimuth floatValue] tilt: [tilt floatValue] duration: [duration floatValue] animation: [animation intValue]];
    }];
}

RCT_EXPORT_METHOD(setZoom:(nonnull NSNumber*) reactTag zoom:(NSNumber*_Nonnull) zoom duration:(NSNumber*_Nonnull) duration animation:(NSNumber*_Nonnull) animation) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNCYMView *view = (RNCYMView*) viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNCYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }
        [view setZoom: [zoom floatValue] withDuration:[duration floatValue] withAnimation:[animation intValue]];
    }];
}

RCT_EXPORT_METHOD(getCameraPosition:(nonnull NSNumber*) reactTag _id:(NSString*_Nonnull) _id) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNCYMView *view = (RNCYMView*) viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNCYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }
        [view emitCameraPositionToJS:_id];
    }];
}

RCT_EXPORT_METHOD(getVisibleRegion:(nonnull NSNumber*) reactTag _id:(NSString*_Nonnull) _id) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        RNCYMView *view = (RNCYMView*) viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[RNCYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }
        [view emitVisibleRegionToJS:_id];
    }];
}

RCT_EXPORT_METHOD(getScreenPoints:(nonnull NSNumber *)reactTag json:(id)json _id:(NSString *_Nonnull)_id) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RNYMView *view = (RNYMView *)viewRegistry[reactTag];

        if (!view || ![view isKindOfClass:[RNYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }

        NSArray<YMKPoint *> *mapPoints = [RCTConvert Points:json];
        [view emitWorldToScreenPoint:mapPoints withId:_id];
    }];
}

RCT_EXPORT_METHOD(getWorldPoints:(nonnull NSNumber *)reactTag json:(id)json _id:(NSString *_Nonnull)_id) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        RNYMView *view = (RNYMView *)viewRegistry[reactTag];

        if (!view || ![view isKindOfClass:[RNYMView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
            return;
        }

        NSArray<YMKScreenPoint *> *screenPoints = [RCTConvert ScreenPoints:json];
        [view emitScreenToWorldPoint:screenPoints withId:_id];
    }];
}

@end
