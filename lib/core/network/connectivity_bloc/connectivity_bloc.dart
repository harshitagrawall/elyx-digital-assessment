import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityBloc({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(ConnectivityInitial()) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);

    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    });

    on<CheckConnectivityEvent>((event, emit) async {
      final isConnected = await _checkConnection();
      add(ConnectivityChanged(isConnected));
    });

    _checkInitialConnection();
  }

  void _onConnectivityChanged(ConnectivityResult result) async {
    final isConnected = await _checkConnection();
    add(ConnectivityChanged(isConnected));
  }

  Future<bool> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  Future<void> _checkInitialConnection() async {
    final isConnected = await _checkConnection();
    add(ConnectivityChanged(isConnected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
