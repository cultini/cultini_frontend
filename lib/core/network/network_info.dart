import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection connectionChecker;

  NetworkInfoImpl({
    required this.connectivity,
    required this.connectionChecker,
  });

  @override
  Future<bool> get isConnected async {
    try {
      final results = await connectivity.checkConnectivity();

      // If ONLY 'none' → no connection
      if (results.length == 1 && results.contains(ConnectivityResult.none)) {
        return false;
      }

      // On web the deep reachability check (HEAD requests to external probe
      // URLs) is blocked by the browser's CORS policy and always reports
      // "offline", which would silently kill every API call before it's sent.
      // Trust connectivity_plus alone here and let the real request surface
      // any failure.
      if (kIsWeb) {
        return true;
      }

      final hasInternet = await connectionChecker.hasInternetAccess.timeout(
        const Duration(seconds: 10),
      );

      return hasInternet;
    } catch (e) {
      debugPrint('Network check error: $e');
      return false;
    }
  }
}
