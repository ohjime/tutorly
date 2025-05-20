import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

final _prettyEncoder = const JsonEncoder.withIndent('  ');

class CoreObserver extends BlocObserver {
  void _printHeader(String type, BlocBase bloc) {
    print('\n========== $type: ${bloc.runtimeType} ==========');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _printHeader('Create', bloc);
    print('Initial State: ${bloc.state}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _printHeader('Event', bloc);
    _safePrint(event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _printHeader('Change', bloc);
    _safePrint(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _printHeader('Transition', bloc);
    _safePrint(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _printHeader('Error', bloc);
    print('Error: $error\nStackTrace:\n$stackTrace');
  }

  void _safePrint(Object? data) {
    try {
      final encoded = _prettyEncoder.convert(_toEncodable(data));
      print(encoded);
    } catch (_) {
      print(data);
    }
  }

  dynamic _toEncodable(Object? data) {
    // If it's already a Map or List, we assume it's JSON-encodable.
    if (data is Map || data is List) return data;
    // Try converting via .toJson() if available
    try {
      return (data as dynamic).toJson();
    } catch (_) {
      return data.toString(); // Fallback to string
    }
  }
}
