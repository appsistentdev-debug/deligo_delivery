part of 'connectivity_cubit.dart';

class ConnectivityState {
  final bool isConnected;
  ConnectivityState(this.isConnected);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConnectivityState && other.isConnected == isConnected;
  }

  @override
  int get hashCode => isConnected.hashCode;
}
