import 'package:pedalea_a_la_mili/rutas/ruta_occidente.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../home_page/home_page_widget.dart' show loginID;
import '../index.dart' show currentUrl;
import 'dart:async';
import 'dart:convert';

import 'yaen_ruta1_model.dart';
export 'yaen_ruta1_model.dart';

const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1Ijoia2Vyb3JlcyIsImEiOiJjbHJndzFxdmkwbG5nMnBxbW80eGZibml0In0.y3yPkMenroJ7DaWvNP2QcA';
const MAPBOX_STYLE = 'mapbox/streets-v12';
const MARKER_COLOR = Color(0xFF023047);
const LINE_COLOR = Color(0xFFFFB600);

class YaenRuta1Widget extends StatefulWidget {
  const YaenRuta1Widget({Key? key}) : super(key: key);

  @override
  _YaenRuta1WidgetState createState() => _YaenRuta1WidgetState();
}

class _YaenRuta1WidgetState extends State<YaenRuta1Widget>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey;

  late final AnimationController _controller;

  _YaenRuta1WidgetState() : scaffoldKey = GlobalKey<ScaffoldState>();

  final _pageController = PageController();

  late latlong.LatLng mainPosition = latlong.LatLng(4.683488, -74.042486);
  late latlong.LatLng mainPositionCenter = latlong.LatLng(4.642276, -74.073584);
  late latlong.LatLng otherPosition = latlong.LatLng(4.759670, -74.042400);
  late YaenRuta1Model _model;

  late Timer locationTimer;

// ! Back Queries
  getUserEmergencyCel() async {
    try {
      var url = Uri.parse('$currentUrl/getUser/$loginID');
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);
      String str = data['celEmergency'];
      String num = str.replaceAll(RegExp(r'\D'), '');
      return num;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<Marker> _buildMarkers() {
    final _markerList = <Marker>[];
    final _polylinePoints = <latlong.LatLng>[];

    for (int i = 0; i < mapMarkersR1.length; i++) {
      final mapItem = mapMarkersR1[i];

      // Agregar marcador
      _markerList.add(
        Marker(
          height: 18,
          width: 18,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
                print('Selected_ ${mapItem.adress}');
              },
              child: Image.asset('assets/images/Marker.png'),
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

    for (int i = 0; i < mapMarkersR1.length; i++) {
      final mapItem = mapMarkersR1[i];
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

  // Función para obtener la dirección
  Future<String?> obtenerDireccion(double latitud, double longitud) async {
    final String apiUrl =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$longitud,$latitud.json?access_token=$MAPBOX_ACCESS_TOKEN';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('features') &&
            responseData['features'] is List &&
            (responseData['features'] as List).isNotEmpty) {
          final List<dynamic> featuresList = responseData['features'] as List;

          if (featuresList[0] is Map<String, dynamic>) {
            // Retornar el valor de la dirección
            return featuresList[0]['place_name'] as String;
          }
        }
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }

    // Si hubo un error o no se encontró la dirección, retornar null
    return null;
  }

  List<String> destinatario = [];

  void initDestinatario() async {
    String? num = await getUserEmergencyCel();
    destinatario = ["57$num"];
    debugPrint("Destinatario: $num");
  }

  void enviarMensaje(List<String> numero, String mensaje) async {
    final double latitud = mainPosition.latitude;
    final double longitud = mainPosition.longitude;

    final String? direccion = await obtenerDireccion(latitud, longitud);

    if (direccion != null) {
      final String mensajeConUbicacion =
          '$mensaje\nMi dirección aproximada es: $direccion\nhttps://www.google.com/maps?q=$latitud,$longitud';

      final Uri uriwsp =
          Uri.parse('https://wa.me/$numero?text=$mensajeConUbicacion');

      if (await canLaunch(uriwsp.toString())) {
        await launch(uriwsp.toString());
      } else {
        print('No se pudo abrir Whatsapp.');
      }
    }
  }

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                27.0), // Radio de borde del cuadro de diálogo
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: 120.0), // Ancho fijo del botón
                child: ElevatedButton(
                  onPressed: () {
                    enviarMensaje(destinatario,
                        'Necesito ayuda, mi bicicleta tuvo un daño.');
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023047), // Fondo del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Radio de borde del botón
                    ),
                  ),
                  child: Text(
                    'Daño',
                    style: TextStyle(
                      fontFamily: 'Eras',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0), // Espacio entre botones
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: 120.0), // Ancho fijo del botón
                child: ElevatedButton(
                  onPressed: () {
                    enviarMensaje(
                        destinatario, 'Me acaban de robar la bicicleta.');
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023047), // Fondo del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Radio de borde del botón
                    ),
                  ),
                  child: Text(
                    'Robo',
                    style: TextStyle(
                      fontFamily: 'Eras',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0), // Espacio entre botones
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: 120.0), // Ancho fijo del botón
                child: ElevatedButton(
                  onPressed: () {
                    enviarMensaje(destinatario,
                        '¡Emergencia! He tenido un accidente en mi bicicleta.');
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023047), // Fondo del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Radio de borde del botón
                    ),
                  ),
                  child: Text(
                    'Accidente',
                    style: TextStyle(
                      fontFamily: 'Eras',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    startLocationUpdates();
    super.initState();
    _model = createModel(context, () => YaenRuta1Model());
    _mapController = MapController();

    // Inicializar el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          seconds: 60), // Duración de la animación (5 segundos en este caso)
    );

    // Iniciar la animación
    _controller.repeat(reverse: false);

    initDestinatario();
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
                        zoom: 12.5,
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
                                latlong.LatLng(4.661459, -74.097073),
                                latlong.LatLng(4.680851, -74.082577),
                                latlong.LatLng(4.687693, -74.074042),
                                latlong.LatLng(4.688526, -74.064131),
                                latlong.LatLng(4.683488, -74.042486)
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
                        itemCount: mapMarkersR1.length,
                        itemBuilder: (context, index) {
                          final item = mapMarkersR1[index];
                          return _MapItemDetails(
                            mapMarkerR1: item,
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
                                          sigmaX: 9.0,
                                          sigmaY: 9.0,
                                        ),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.00, 0.00),
                                          child: Container(
                                            width: 350.0,
                                            height: 358.0,
                                            decoration: BoxDecoration(
                                              color: Color(0x5DFFFFFF),
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
                                    alignment:
                                        AlignmentDirectional(0.00, -0.25),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.00, -1.00),
                                                    child: Container(
                                                      width: 15.0,
                                                      height: 15.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.00, -1.00),
                                                    child: Container(
                                                      width: 15.0,
                                                      height: 15.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.00, -1.00),
                                                    child: Container(
                                                      width: 15.0,
                                                      height: 15.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.00, -1.00),
                                                    child: Container(
                                                      width: 15.0,
                                                      height: 15.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.00, -1.00),
                                                    child: Container(
                                                      width: 15.0,
                                                      height: 15.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        shape: BoxShape.circle,
                                                      ),
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
                                                                0.0, 3.0),
                                                    child: Text(
                                                      'Plaza Claro - 6:10 am',
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
                                                                0.0, 3.0),
                                                    child: Text(
                                                      'Simón Bolívar - 6:15 am',
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
                                                                0.0, 3.0),
                                                    child: Text(
                                                      'Metrópolis - 6:25 am',
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
                                                    'Cafam Floresta - 6:35 am',
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
                                                    'Iserra 100 - 6:40 am',
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
                                    alignment: AlignmentDirectional(0.00, 0.48),
                                    child: FFButtonWidget(
                                      onPressed: () {
                                        _mostrarDialogo(context);
                                      },
                                      text: 'Mandar Alarma',
                                      options: FFButtonOptions(
                                        height: 36.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            15.0, 0.0, 15.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Eras',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
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
                                  Align(
                                    alignment: AlignmentDirectional(0.00, 0.85),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        context.pushNamed('RutasRecomendadas');
                                      },
                                      text: 'Salir de la Ruta',
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

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({
    Key? key,
    required this.mapMarkerR1,
  }) : super(key: key);

  final MapMarkerR1 mapMarkerR1;

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
                        mapMarkerR1.adress,
                        style: _style,
                      ),
                      Text(
                        mapMarkerR1.time,
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
