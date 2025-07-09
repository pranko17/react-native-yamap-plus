package ru.vvdev.yamap

import android.view.View
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp
import com.yandex.mapkit.MapKitFactory
import com.yandex.mapkit.map.CameraPosition
import ru.vvdev.yamap.events.yamap.CameraPositionChangeEndEvent
import ru.vvdev.yamap.events.yamap.CameraPositionChangeEvent
import ru.vvdev.yamap.events.yamap.GetCameraPositionEvent
import ru.vvdev.yamap.events.yamap.GetScreenToWorldPointsEvent
import ru.vvdev.yamap.events.yamap.GetVisibleRegionEvent
import ru.vvdev.yamap.events.yamap.GetWorldToScreenPointsEvent
import ru.vvdev.yamap.events.yamap.MapLoadedEvent
import ru.vvdev.yamap.events.yamap.YamapLongPressEvent
import ru.vvdev.yamap.events.yamap.YamapPressEvent
import ru.vvdev.yamap.utils.PointUtil
import ru.vvdev.yamap.view.YamapView
import javax.annotation.Nonnull

class YamapViewManager internal constructor() : ViewGroupManager<YamapView>() {
    override fun getName(): String {
        return REACT_CLASS
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
        return mapOf()
    }

    override fun getExportedCustomBubblingEventTypeConstants(): MutableMap<String, Any> {
        return mutableMapOf(
            GetCameraPositionEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onCameraPositionReceived")
                    ),
            CameraPositionChangeEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onCameraPositionChange")
                    ),
            CameraPositionChangeEndEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onCameraPositionChangeEnd")
                    ),
            GetVisibleRegionEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onVisibleRegionReceived")
                    ),
            YamapPressEvent.EVENT_NAME to
                    mapOf("phasedRegistrationNames" to
                            mapOf("bubbled" to "onMapPress")
                    ),
            YamapLongPressEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onMapLongPress")
                    ),
            MapLoadedEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onMapLoaded")
                    ),
            GetScreenToWorldPointsEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onScreenToWorldPointsReceived")
                    ),
            GetWorldToScreenPointsEvent.EVENT_NAME to
                    mapOf(
                        "phasedRegistrationNames" to
                                mapOf("bubbled" to "onWorldToScreenPointsReceived")
                    ),
            )
    }

    override fun getCommandsMap(): Map<String, Int> {
        return mapOf(
            "setCenter" to SET_CENTER,
            "fitAllMarkers" to FIT_ALL_MARKERS,
            "setZoom" to SET_ZOOM,
            "getCameraPosition" to GET_CAMERA_POSITION,
            "getVisibleRegion" to GET_VISIBLE_REGION,
            "setTrafficVisible" to SET_TRAFFIC_VISIBLE,
            "fitMarkers" to FIT_MARKERS,
            "getScreenPoints" to GET_SCREEN_POINTS,
            "getWorldPoints" to GET_WORLD_POINTS,
        )
    }

    override fun receiveCommand(
        view: YamapView,
        commandType: String,
        args: ReadableArray?
    ) {
        if (args === null) return

        when (commandType) {
            "setCenter" -> setCenter(
                castToYamapView(view),
                args.getMap(0),
                args.getDouble(1).toFloat(),
                args.getDouble(2).toFloat(),
                args.getDouble(3).toFloat(),
                args.getDouble(4).toFloat(),
                args.getInt(5)
            )
            "fitAllMarkers" -> fitAllMarkers(view, args.getDouble(0).toFloat(), args.getInt(1))
            "fitMarkers" -> fitMarkers(view, args.getArray(0), args.getDouble(1).toFloat(), args.getInt(2))
            "setZoom" -> view.setZoom(
                args.getDouble(0).toFloat(),
                args.getDouble(1).toFloat(),
                args.getInt(2)
            )
            "getCameraPosition" -> view.emitCameraPositionToJS(args.getString(0))
            "getVisibleRegion" -> view.emitVisibleRegionToJS(args.getString(0))
            "setTrafficVisible" -> view.setTrafficVisible(args.getBoolean(0))
            "getScreenPoints" -> view.emitWorldToScreenPoints(
                args.getArray(0),
                args.getString(1)
            )
            "getWorldPoints" -> view.emitScreenToWorldPoints(
                args.getArray(0),
                args.getString(1)
            )

            else -> throw IllegalArgumentException(
                String.format(
                    "Unsupported command %d received by %s.",
                    commandType,
                    javaClass.simpleName
                )
            )
        }
    }

    private fun castToYamapView(view: View): YamapView {
        return view as YamapView
    }

    @Nonnull
    public override fun createViewInstance(@Nonnull context: ThemedReactContext): YamapView {
        val view = YamapView(context)
        MapKitFactory.getInstance().onStart()
        view.onStart()

        return view
    }

    private fun setCenter(
        view: YamapView,
        center: ReadableMap?,
        zoom: Float,
        azimuth: Float,
        tilt: Float,
        duration: Float,
        animation: Int
    ) {
        center?.let {
            val point = PointUtil.readableMapToPoint(it)
            val position = CameraPosition(point, zoom, azimuth, tilt)
            view.setCenter(position, duration, animation)
        }
    }

    private fun fitAllMarkers(view: View, duration: Float, animation: Int) {
        castToYamapView(view).fitAllMarkers(duration, animation)
    }

    private fun fitMarkers(view: View, jsPoints: ReadableArray?, duration: Float, animation: Int) {
        if (jsPoints != null) {
            val points = PointUtil.jsPointsToPoints(jsPoints)
            castToYamapView(view).fitMarkers(points, duration, animation)
        }
    }

    // PROPS
    @ReactProp(name = "userLocationIcon")
    fun setUserLocationIcon(view: View, icon: String?) {
        if (icon != null) {
            castToYamapView(view).setUserLocationIcon(icon)
        }
    }

    @ReactProp(name = "userLocationIconScale")
    fun setUserLocationIconScale(view: View, scale: Float) {
        castToYamapView(view).setUserLocationIconScale(scale)
    }

    @ReactProp(name = "userLocationAccuracyFillColor")
    fun setUserLocationAccuracyFillColor(view: View, color: Int) {
        castToYamapView(view).setUserLocationAccuracyFillColor(color)
    }

    @ReactProp(name = "userLocationAccuracyStrokeColor")
    fun setUserLocationAccuracyStrokeColor(view: View, color: Int) {
        castToYamapView(view).setUserLocationAccuracyStrokeColor(color)
    }

    @ReactProp(name = "userLocationAccuracyStrokeWidth")
    fun setUserLocationAccuracyStrokeWidth(view: View, width: Float) {
        castToYamapView(view).setUserLocationAccuracyStrokeWidth(width)
    }

    @ReactProp(name = "showUserPosition")
    fun setShowUserPosition(view: View, show: Boolean?) {
        castToYamapView(view).setShowUserPosition(show!!)
    }

    @ReactProp(name = "nightMode")
    fun setNightMode(view: View, nightMode: Boolean?) {
        castToYamapView(view).setNightMode(nightMode ?: false)
    }

    @ReactProp(name = "scrollGesturesEnabled")
    fun setScrollGesturesEnabled(view: View, scrollGesturesEnabled: Boolean) {
        castToYamapView(view).setScrollGesturesEnabled(scrollGesturesEnabled)
    }

    @ReactProp(name = "rotateGesturesEnabled")
    fun setRotateGesturesEnabled(view: View, rotateGesturesEnabled: Boolean) {
        castToYamapView(view).setRotateGesturesEnabled(rotateGesturesEnabled)
    }

    @ReactProp(name = "zoomGesturesEnabled")
    fun setZoomGesturesEnabled(view: View, zoomGesturesEnabled: Boolean) {
        castToYamapView(view).setZoomGesturesEnabled(zoomGesturesEnabled)
    }

    @ReactProp(name = "tiltGesturesEnabled")
    fun setTiltGesturesEnabled(view: View, tiltGesturesEnabled: Boolean) {
        castToYamapView(view).setTiltGesturesEnabled(tiltGesturesEnabled)
    }

    @ReactProp(name = "fastTapEnabled")
    fun setFastTapEnabled(view: View, fastTapEnabled: Boolean) {
        castToYamapView(view).setFastTapEnabled(fastTapEnabled)
    }

    @ReactProp(name = "mapStyle")
    fun setMapStyle(view: View, style: String?) {
        if (style != null) {
            castToYamapView(view).setMapStyle(style)
        }
    }

    @ReactProp(name = "mapType")
    fun setMapType(view: View, type: String?) {
        if (type != null) {
            castToYamapView(view).setMapType(type)
        }
    }

    @ReactProp(name = "initialRegion")
    fun setInitialRegion(view: View, params: ReadableMap?) {
        if (params != null) {
            castToYamapView(view).setInitialRegion(params)
        }
    }

    @ReactProp(name = "interactive")
    fun setInteractive(view: View, interactive: Boolean) {
        castToYamapView(view).setInteractive(interactive)
    }

    @ReactProp(name = "logoPosition")
    fun setLogoPosition(view: View, params: ReadableMap?) {
        if (params != null) {
            castToYamapView(view).setLogoPosition(params)
        }
    }

    @ReactProp(name = "logoPadding")
    fun setLogoPadding(view: View, params: ReadableMap?) {
        if (params != null) {
            castToYamapView(view).setLogoPadding(params)
        }
    }

    override fun addView(parent: YamapView, child: View, index: Int) {
        parent.addFeature(child, index)
        super.addView(parent, child, index)
    }

    override fun removeViewAt(parent: YamapView, index: Int) {
        parent.removeChild(index)
        super.removeViewAt(parent, index)
    }

    companion object {
        const val REACT_CLASS: String = "YamapView"

        private const val SET_CENTER = 1
        private const val FIT_ALL_MARKERS = 2
        private const val SET_ZOOM = 3
        private const val GET_CAMERA_POSITION = 4
        private const val GET_VISIBLE_REGION = 5
        private const val SET_TRAFFIC_VISIBLE = 6
        private const val FIT_MARKERS = 7
        private const val GET_SCREEN_POINTS = 8
        private const val GET_WORLD_POINTS = 9
    }
}
