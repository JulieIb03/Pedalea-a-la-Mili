import 'package:pedalea_a_la_mili/rutas/ruta_norte.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
/*import 'package:location/location.dart';*/

import 'unirsea_ruta2_model.dart';
export 'unirsea_ruta2_model.dart';

const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1Ijoia2Vyb3JlcyIsImEiOiJjbHJndzFxdmkwbG5nMnBxbW80eGZibml0In0.y3yPkMenroJ7DaWvNP2QcA';
const MAPBOX_STYLE = 'mapbox/streets-v12';
const MARKER_COLOR = Color(0xFF023047);
const LINE_COLOR = Color(0xFF1DAEEF);

// Configurar la imagen, ancho y alto predeterminados
const MARKER_SIZE_EXPANDED = 30.0;
const MARKER_SIZE_SHRINKED = 18.0;

class UnirseaRuta2Widget extends StatefulWidget {
  @override
  _UnirseaRuta2WidgetState createState() => _UnirseaRuta2WidgetState();
}

class _UnirseaRuta2WidgetState extends State<UnirseaRuta2Widget>
    with TickerProviderStateMixin {
  int? selectedRadioValue;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey;

  late final AnimationController _controller;

  _UnirseaRuta2WidgetState() : scaffoldKey = GlobalKey<ScaffoldState>();

  final _pageController = PageController();

  late latlong.LatLng mainPosition = latlong.LatLng(4.683488, -74.042486);
  late latlong.LatLng mainPositionCenter = latlong.LatLng(4.683488, -74.042486);
  late latlong.LatLng otherPosition = latlong.LatLng(4.759670, -74.042400);
  late UnirseaRuta2Model _model;

  late Timer locationTimer;

  List<Marker> _buildMarkers() {
    final _markerList = <Marker>[];
    final _polylinePoints = <latlong.LatLng>[];

    for (int i = 0; i < mapMarkersR2.length; i++) {
      final mapItem = mapMarkersR2[i];

      // Agregar marcador
      _markerList.add(
        Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _selectedIndex = i;
                setState(() {
                  _pageController.animateToPage(i,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                  print('Selected_ ${mapItem.adress}');
                });
              },
              child: _LocationMarker(
                selected: _selectedIndex == i,
              ),
            );
          },
        ),
      );

      // Agregar punto al polyline
      _polylinePoints.add(mapItem.location);
    }

    // Crear polyline
    final polyline = Polyline(
      points: _polylinePoints,
      color: LINE_COLOR,
      strokeWidth: 2.0,
    );

    return _markerList;
  }

  List<Polyline> _buildPolylines() {
    final _polylinePoints = <latlong.LatLng>[];

    for (int i = 0; i < mapMarkersR2.length; i++) {
      final mapItem = mapMarkersR2[i];
      _polylinePoints.add(mapItem.location);
    }

    // Crear polyline
    final polyline = Polyline(
      points: _polylinePoints,
      color: LINE_COLOR,
      strokeWidth: 6.0,
    );

    return [polyline];
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      mainPosition = latlong.LatLng(position.latitude, position.longitude);
      mainPositionCenter =
          latlong.LatLng(position.latitude - 0.003, position.longitude);
      /*if (_mapController != null) {
        _mapController.move(mainPositionCenter, 12.0);
      }*/
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    startLocationUpdates();
    super.initState();
    selectedRadioValue = 0;
    _model = createModel(context, () => UnirseaRuta2Model());
    _mapController = MapController();

    // Inicializar el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          seconds: 60), // Duración de la animación (5 segundos en este caso)
    );

    // Iniciar la animación
    _controller.repeat(reverse: false);
  }

  void startLocationUpdates() {
    locationTimer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      getCurrentLocation();
    });
  }

  void stopLocationUpdates() {
    locationTimer.cancel();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    _model.dispose();
    _controller.dispose();
    super.dispose();
  }

  late MapController _mapController;

  @override
  Widget build(BuildContext context) {
    final _markers = _buildMarkers();

    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondary,
                ),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                  child: Image.asset(
                    'assets/images/pedalea-logo.png',
                    width: 315.0,
                    height: 98.0,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: mainPositionCenter,
                        minZoom: 3,
                        maxZoom: 30,
                        zoom: 12,
                        /*onPositionChanged: (position, hasGesture) {
                          if (hasGesture) {
                            double currentZoom = _mapController.zoom;
                            print("Nuevo zoom: $currentZoom");
                          }
                        },*/
                      ),
                      nonRotatedChildren: [
                        TileLayer(
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                          additionalOptions: {
                            'accessToken': MAPBOX_ACCESS_TOKEN,
                            'id': MAPBOX_STYLE,
                          },
                        ),
                        PolylineLayer(polylines: _buildPolylines()),
                        MarkerLayer(
                          markers: _markers,
                        ),
                        MarkerLayer(
                          markers: [
                            createCustomMarker(
                              context,
                              mainPosition,
                              AssetImage('assets/images/Usuario.png'),
                            ),
                            createAnimatedMarker(
                              context,
                              [
                                latlong.LatLng(4.759670, -74.042400),
                                latlong.LatLng(4.748036, -74.031591)
                              ],
                              AssetImage('assets/images/Lider.png'),
                              true, // Animar el marcador
                              _controller, // Controlador de animación
                            ),
                          ],
                        ),
                      ],
                    ),
                    //PageView Paradas
                    Positioned(
                      left: 190,
                      right: 24,
                      top: 21,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: mapMarkersR2.length,
                        itemBuilder: (context, index) {
                          final item = mapMarkersR2[index];
                          return _MapItemDetails(
                            mapMarkerR2: item,
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.00, 0.00),
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.90),
                            child: Container(
                              width: 346.0,
                              height: 380.0,
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  Align(
                                    alignment:
                                        AlignmentDirectional(0.00, -1.00),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10.0,
                                          sigmaY: 10.0,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.00, 0.00),
                                          child: Container(
                                            width: 350.0,
                                            height: 358.0,
                                            decoration: BoxDecoration(
                                              color: Color(0x15FFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional(0.00, -0.75),
                                    child: Container(
                                      width: 350.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .customColor1,
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.80, 0.40),
                                        child: Text(
                                          'Estado: Hacia la Universidad',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Eras',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                useGoogleFonts: false,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional(0.00, -0.45),
                                    child: Container(
                                      width: 268.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBtnText,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 12.0,
                                            color: Color(0x63023047),
                                            offset: Offset(4.0, 7.0),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.00, 0.00),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -0.80, 0.00),
                                              child: Text(
                                                'Seleccionar Punto',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Eras',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          useGoogleFonts: false,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional(0.00, -1.08),
                                    child: Container(
                                      width: 350.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1DAEEF),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0.0),
                                          bottomRight: Radius.circular(0.0),
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.00, 0.00),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -0.80, 0.00),
                                              child: Text(
                                                '2',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 36.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.80, 0.00),
                                              child: Text(
                                                'Ruta Norte',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Eras',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          fontSize: 21.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          useGoogleFonts: false,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.00, 0.30),
                                    child: Container(
                                      width: 313.0,
                                      height: 160.0,
                                      decoration: BoxDecoration(),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.00, -1.00),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.00, -1.00),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Theme(
                                                    data: ThemeData(
                                                      radioTheme:
                                                          RadioThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Radio(
                                                      value:
                                                          1, // Valor único para esta opción
                                                      groupValue: _model
                                                          .selectedRadioValue, // Valor seleccionado actual
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _model.selectedRadioValue =
                                                              value
                                                                  as int; // Actualiza el valor seleccionado
                                                        });
                                                      },
                                                      activeColor:
                                                          Color(0xFF1DAEEF),
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: ThemeData(
                                                      radioTheme:
                                                          RadioThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Radio(
                                                      value:
                                                          2, // Valor único para esta opción
                                                      groupValue: _model
                                                          .selectedRadioValue, // Valor seleccionado actual
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _model.selectedRadioValue =
                                                              value
                                                                  as int; // Actualiza el valor seleccionado
                                                        });
                                                      },
                                                      activeColor:
                                                          Color(0xFF1DAEEF),
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: ThemeData(
                                                      radioTheme:
                                                          RadioThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Radio(
                                                      value:
                                                          3, // Valor único para esta opción
                                                      groupValue: _model
                                                          .selectedRadioValue, // Valor seleccionado actual
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _model.selectedRadioValue =
                                                              value
                                                                  as int; // Actualiza el valor seleccionado
                                                        });
                                                      },
                                                      activeColor:
                                                          Color(0xFF1DAEEF),
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: ThemeData(
                                                      radioTheme:
                                                          RadioThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Radio(
                                                      value:
                                                          4, // Valor único para esta opción
                                                      groupValue: _model
                                                          .selectedRadioValue, // Valor seleccionado actual
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _model.selectedRadioValue =
                                                              value
                                                                  as int; // Actualiza el valor seleccionado
                                                        });
                                                      },
                                                      activeColor:
                                                          Color(0xFF1DAEEF),
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: ThemeData(
                                                      radioTheme:
                                                          RadioThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Radio(
                                                      value:
                                                          5, // Valor único para esta opción
                                                      groupValue: _model
                                                          .selectedRadioValue, // Valor seleccionado actual
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _model.selectedRadioValue =
                                                              value
                                                                  as int; // Actualiza el valor seleccionado
                                                        });
                                                      },
                                                      activeColor:
                                                          Color(0xFF1DAEEF),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.00, 0.00),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 6.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      'Cra 20 #182-35 - 6:10 am',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Eras',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                useGoogleFonts:
                                                                    false,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.00, 0.00),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      'Cl 170 con caño - 6:15 am',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Eras',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                useGoogleFonts:
                                                                    false,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.00, 0.00),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      'Cra 9 con Cl 153 - 6:25 am',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Eras',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondary,
                                                                useGoogleFonts:
                                                                    false,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.00, 0.00),
                                                  child: Text(
                                                    'Cra 9 con Cl 134 - 6:35 am',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Eras',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.00, 0.00),
                                                  child: Text(
                                                    'Cra 127 con Cra 11 - 6:40 am',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Eras',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondary,
                                                          useGoogleFonts: false,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.00, 0.87),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        context.pushNamed('YaenRuta2');
                                      },
                                      text: 'Aceptar',
                                      options: FFButtonOptions(
                                        height: 40.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Eras',
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              useGoogleFonts: false,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 20.0, 20.0, 20.0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('HomePage');
                              },
                              child: Container(
                                width: 60.0,
                                height: 60.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 2.0,
                                          sigmaY: 2.0,
                                        ),
                                        child: Container(
                                          width: 70.0,
                                          height: 70.0,
                                          decoration: BoxDecoration(
                                            color: Color(0x14FFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
                                      child: Icon(
                                        Icons.power_settings_new,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        size: 32.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({Key? key, this.selected = false}) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED;
    return Center(
      child: AnimatedContainer(
        height: size,
        width: size,
        duration: Duration(milliseconds: 400),
        child: Image.asset('assets/images/Marker.png'),
      ),
    );
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({
    Key? key,
    required this.mapMarkerR2,
  }) : super(key: key);

  final MapMarkerR2 mapMarkerR2;

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        fontFamily: 'Eras',
        color: FlutterFlowTheme.of(context).secondary,
        fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY:
                  5.0), // Ajusta el valor de sigmaX y sigmaY según sea necesario
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
            ),
            // Tu contenido dentro del contenedor aquí
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        mapMarkerR2.adress,
                        style: _style,
                      ),
                      Text(
                        mapMarkerR2.time,
                        style: _style,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Marker createCustomMarker(
    BuildContext context, latlong.LatLng position, ImageProvider image) {
  Color color = FlutterFlowTheme.of(context).secondary;

  return Marker(
    point: position,
    builder: (context) {
      return Container(
        child: Image(
          image: image,
          width: 40,
          height: 40,
        ),
      );
    },
  );
}

class LatLngTween extends Tween<latlong.LatLng> {
  final List<latlong.LatLng> points;

  LatLngTween({required this.points})
      : super(begin: points.first, end: points.last);

  @override
  latlong.LatLng lerp(double t) {
    final int index = ((points.length - 1) * t).floor();
    final double localT = (points.length - 1) * t - index;

    final latlong.LatLng point1 = points[index];
    final latlong.LatLng point2 = points[index + 1];

    return latlong.LatLng(
      lerpDouble(point1.latitude, point2.latitude, localT)!,
      lerpDouble(point1.longitude, point2.longitude, localT)!,
    );
  }
}

Marker createAnimatedMarker(
    BuildContext context,
    List<latlong.LatLng> positions,
    ImageProvider markerImage,
    bool animate,
    AnimationController controller) {
  final LatLngTween tween = LatLngTween(points: positions);

  return Marker(
    width: 50.0,
    height: 50.0,
    point: tween
        .animate(controller)
        .value, // Obtener la posición interpolada basada en el valor de la animación
    builder: (ctx) {
      // Si se debe animar el marcador, aplicar la animación
      if (animate) {
        return Container(
          child: Image(image: markerImage), // Imagen del marcador
        );
      } else {
        // Si no se debe animar, simplemente mostrar la imagen del marcador
        return Container(
          child: Image(image: markerImage), // Imagen del marcador
        );
      }
    },
  );
}
