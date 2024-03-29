import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'rutas_recomendadas_model.dart';
export 'rutas_recomendadas_model.dart';

const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1Ijoia2Vyb3JlcyIsImEiOiJjbHJndzFxdmkwbG5nMnBxbW80eGZibml0In0.y3yPkMenroJ7DaWvNP2QcA';
const MAPBOX_STYLE = 'mapbox/streets-v12';
const MARKER_COLOR = Color(0xFF023047);

/*final mainPosition = latlong.LatLng(4.683488, -74.042486);*/

class RutasRecomendadasWidget extends StatefulWidget {
  const RutasRecomendadasWidget({Key? key}) : super(key: key);

  @override
  _RutasRecomendadasWidgetState createState() =>
      _RutasRecomendadasWidgetState();
}

class _RutasRecomendadasWidgetState extends State<RutasRecomendadasWidget> {
  late latlong.LatLng mainPosition = latlong.LatLng(4.683488, -74.042486);
  late RutasRecomendadasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isButtonPressed = false;

  /*void solicitarPermisosSMS() async {
    var status = await Permission.sms.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.sms.request();
      if (status != PermissionStatus.granted) {}
    }
  }*/

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      //solicitarPermisosSMS();
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
      _mapController.move(mainPosition, 18.0);
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    _model = createModel(context, () => RutasRecomendadasModel());
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
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
                      zoom: 18,
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
                            height: 200.0,
                            child: Stack(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.00, 0.60),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10.0,
                                        sigmaY: 10.0,
                                      ),
                                      child: Container(
                                        width: 350.0,
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(19, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.00, -0.50),
                                  child: Container(
                                    width: 350.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondary,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0.0),
                                        bottomRight: Radius.circular(0.0),
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(0.00, 0.00),
                                      child: Text(
                                        'Rutas Activas',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBtnText,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.00, 0.50),
                                  child: InkWell(
                                    splashColor:
                                        const Color.fromARGB(0, 243, 13, 13),
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed('UnirseaRuta');
                                    },
                                    child: Container(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(0.00, 0.00),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _buildButton(1, 'Ruta \n Occidente',
                                                Color(0xFFFFB600), context),
                                            SizedBox(width: 9),
                                            _buildButton(2, 'Ruta \n Norte',
                                                Color(0xFF1DAEEF), context),
                                            SizedBox(width: 9),
                                            _buildButton(3, 'Ruta \n Centro',
                                                Color(0xFF552E87), context),
                                            SizedBox(width: 9),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                /*Align(
                                  alignment: AlignmentDirectional(-0.25, 0.50),
                                  child: Container(
                                    width: 20.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(0.0),
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(0.0),
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                        // Dentro del método build de tu widget:
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 20.0, 20.0, 20.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('HomePage');
                                },
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 2.0,
                                            sigmaY: 2.0,
                                          ),
                                          child: Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  19, 255, 255, 255),
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
                            ],
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
    );
  }
}

class SelectedRoute {
  late final int num;

  SelectedRoute(this.num);
}

Widget _buildButton(
    int number, String text, Color buttonColor, BuildContext context) {
  int selectedRoute = 1;

  return Align(
    alignment: AlignmentDirectional(0.00, 0.50),
    child: InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        // Maneja el tap del botón aquí
        switch (number) {
          case 1:
            print('ruta1');
            context.pushNamed('IniciarRuta1');
            break;
          case 2:
            print('ruta2');
            context.pushNamed('IniciarRuta2');
            break;
          case 3:
            print('ruta3');
            context.pushNamed('IniciarRuta3');
            break;
        }
      },
      child: Container(
        width: 100.0,
        height: 70.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBtnText,
          borderRadius: BorderRadius.circular(10.0),
          border: Border(
            left: BorderSide(
              color: buttonColor,
              width: 18.0,
            ),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(-0.70, -0.85),
              child: Text(
                number.toString(),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-0.3, 0.75),
              child: Text(
                text,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                    ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
