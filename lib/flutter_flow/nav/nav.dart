import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedalea_a_la_mili/iniciar_ruta/iniciar_ruta1_widget.dart';
import 'package:pedalea_a_la_mili/iniciar_ruta/iniciar_ruta2_widget.dart';
import 'package:pedalea_a_la_mili/iniciar_ruta/iniciar_ruta3_widget.dart';
import 'package:pedalea_a_la_mili/unirsea_ruta/unirsea_ruta1_widget.dart';
import 'package:pedalea_a_la_mili/unirsea_ruta/unirsea_ruta2_widget.dart';
import 'package:pedalea_a_la_mili/unirsea_ruta/unirsea_ruta3_widget.dart';
import 'package:pedalea_a_la_mili/yaen_ruta/yaen_ruta1_widget.dart';
import 'package:pedalea_a_la_mili/yaen_ruta/yaen_ruta2_widget.dart';
import 'package:pedalea_a_la_mili/yaen_ruta/yaen_ruta3_widget.dart';
import 'package:provider/provider.dart';

import '/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

import 'package:fluro/fluro.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => HomePageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => HomePageWidget(),
          routes: [
            FFRoute(
              name: 'HomePage',
              path: 'homePage',
              builder: (context, params) => HomePageWidget(),
            ),
            FFRoute(
              name: 'InicioAlt',
              path: 'inicio_alt',
              builder: (context, params) => InicioAltWidget(),
            ),
            FFRoute(
              name: 'Registro',
              path: 'registro',
              builder: (context, params) => RegistroWidget(),
            ),
            FFRoute(
              name: 'Registro1',
              path: 'registro1',
              builder: (context, params) => Registro1Widget(),
            ),
            FFRoute(
              name: 'Registro2',
              path: 'registro2',
              builder: (context, params) => Registro2Widget(),
            ),
            FFRoute(
              name: 'RutasRecomendadas',
              path: 'rutasRecomendadas',
              builder: (context, params) => RutasRecomendadasWidget(),
            ),
            FFRoute(
              name: 'IniciarRuta',
              path: 'iniciarRuta',
              builder: (context, params) => IniciarRutaWidget(),
            ),
            FFRoute(
              name: 'IniciarRuta1',
              path: 'iniciarRuta1',
              builder: (context, params) => IniciarRuta1Widget(),
            ),
            FFRoute(
              name: 'IniciarRuta2',
              path: 'iniciarRuta2',
              builder: (context, params) => IniciarRuta2Widget(),
            ),
            FFRoute(
              name: 'IniciarRuta3',
              path: 'iniciarRuta3',
              builder: (context, params) => IniciarRuta3Widget(),
            ),
            FFRoute(
              name: 'UnirseaRuta',
              path: 'unirseaRuta',
              builder: (context, params) => UnirseaRutaWidget(),
            ),
            FFRoute(
              name: 'UnirseaRuta1',
              path: 'unirseaRuta1',
              builder: (context, params) => UnirseaRuta1Widget(),
            ),
            FFRoute(
              name: 'UnirseaRuta2',
              path: 'unirseaRuta2',
              builder: (context, params) => UnirseaRuta2Widget(),
            ),
            FFRoute(
              name: 'UnirseaRuta3',
              path: 'unirseaRuta3',
              builder: (context, params) => UnirseaRuta3Widget(),
            ),
            FFRoute(
              name: 'YaenRuta',
              path: 'yaenRuta',
              builder: (context, params) => YaenRutaWidget(),
            ),
            FFRoute(
              name: 'YaenRuta1',
              path: 'yaenRuta1',
              builder: (context, params) => YaenRuta1Widget(),
            ),
            FFRoute(
              name: 'YaenRuta2',
              path: 'yaenRuta2',
              builder: (context, params) => YaenRuta2Widget(),
            ),
            FFRoute(
              name: 'YaenRuta3',
              path: 'yaenRuta3',
              builder: (context, params) => YaenRuta3Widget(),
            ),
            FFRoute(
              name: 'Estadisticas',
              path: 'estadisticas',
              builder: (context, params) => EstadisticasWidget(),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouter.of(context).location;
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}
