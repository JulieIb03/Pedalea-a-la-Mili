
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
import 'unirsea_ruta_model.dart';
export 'unirsea_ruta_model.dart';

const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1Ijoia2Vyb3JlcyIsImEiOiJjbHJndzFxdmkwbG5nMnBxbW80eGZibml0In0.y3yPkMenroJ7DaWvNP2QcA';
const MAPBOX_STYLE = 'mapbox/streets-v12';
const MARKER_COLOR = Color(0xFF023047);

class UnirseaRutaWidget extends StatefulWidget {
  @override
  _UnirseaRutaWidgetState createState() => _UnirseaRutaWidgetState();
}

class _UnirseaRutaWidgetState extends State<UnirseaRutaWidget> {
  late latlong.LatLng mainPosition = latlong.LatLng(4.683488, -74.042486);
  late latlong.LatLng mainPositionCenter = latlong.LatLng(4.683488, -74.042486);
  late UnirseaRutaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      _mapController.move(mainPositionCenter, 12.0);
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    _model = createModel(context, () => UnirseaRutaModel());
    _mapController = MapController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  late MapController _mapController;

  @override
  Widget build(BuildContext context) {
    final selectedCase = ModalRoute.of(context)?.settings.arguments as int?;

    // Verifica si selectedCase no es nulo antes de usarlo
    if (selectedCase != null) {
      // Haz algo con selectedCase
      switch (selectedCase) {
        case 1:
          print('Seleccionaste la ruta: $selectedCase');
          // Cargar datos desde case1.dart
          break;
        case 2:
          print('Seleccionaste la ruta: $selectedCase');
          // Cargar datos desde case2.dart
          break;
        case 3:
          print('Seleccionaste la ruta: $selectedCase');
          // Cargar datos desde case3.dart
          break;
        // Agrega más casos según sea necesario
      }
    }

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
                        center: mainPosition,
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
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: mainPosition,
                              builder: (context) {
                                return Container(
                                  child: const Icon(
                                    Icons.person_pin,
                                    color: MARKER_COLOR,
                                    size: 40,
                                  ),
                                );
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.00, 0.00),
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.90),
                            child: Container(
                              width: 346.0,
                              height: 353.0,
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
                                        AlignmentDirectional(0.00, -0.40),
                                    child: Container(
                                      width: 268.0,
                                      height: 37.0,
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
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.90, 0.50),
                                              child: Text(
                                                'Punto Sugerido',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Eras',
                                                          color:
                                                              Color(0xFFFB8500),
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FontStyle.italic,
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
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                                                '1',
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
                                                'Ruta Occidente',
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
                                      height: 130.0,
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
                                                      checkboxTheme:
                                                          CheckboxThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Checkbox(
                                                      value: _model
                                                              .checkboxValue1 ??=
                                                          false,
                                                      onChanged:
                                                          (newValue) async {
                                                        setState(() => _model
                                                                .checkboxValue1 =
                                                            newValue!);
                                                      },
                                                      activeColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      checkColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: ThemeData(
                                                      checkboxTheme:
                                                          CheckboxThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Checkbox(
                                                      value: _model
                                                              .checkboxValue2 ??=
                                                          false,
                                                      onChanged:
                                                          (newValue) async {
                                                        setState(() => _model
                                                                .checkboxValue2 =
                                                            newValue!);
                                                      },
                                                      activeColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      checkColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: ThemeData(
                                                      checkboxTheme:
                                                          CheckboxThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Checkbox(
                                                      value: _model
                                                              .checkboxValue3 ??=
                                                          true,
                                                      onChanged:
                                                          (newValue) async {
                                                        setState(() => _model
                                                                .checkboxValue3 =
                                                            newValue!);
                                                      },
                                                      activeColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      checkColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  ),
                                                  Theme(
                                                    data: ThemeData(
                                                      checkboxTheme:
                                                          CheckboxThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                        ),
                                                      ),
                                                      unselectedWidgetColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                    child: Checkbox(
                                                      value: _model
                                                              .checkboxValue4 ??=
                                                          false,
                                                      onChanged:
                                                          (newValue) async {
                                                        setState(() => _model
                                                                .checkboxValue4 =
                                                            newValue!);
                                                      },
                                                      activeColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      checkColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
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
                                                            .fromSTEB(0.0, 2.0,
                                                                0.0, 10.0),
                                                    child: Text(
                                                      'Simón Bolivar - 8:00 A.M.',
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
                                                                0.0, 10.0),
                                                    child: Text(
                                                      'Alkosto Av . 68 - 8:05 A.M.',
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
                                                                0.0, 10.0),
                                                    child: Text(
                                                      'Cruz Roja - SAMU - 8:10 A.M.',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Eras',
                                                            color: Color(
                                                                0xFFFB8500),
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
                                                    'Exito 80 - 8:15 A.M.',
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
                                    alignment: AlignmentDirectional(0.00, 0.85),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        context.pushNamed('YaenRuta');
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
                                    alignment: AlignmentDirectional(0.00, 0.00),
                                    child: FaIcon(
                                      FontAwesomeIcons.userLarge,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      size: 32.0,
                                    ),
                                  ),
                                ],
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
