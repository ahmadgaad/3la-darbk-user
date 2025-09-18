
import 'package:equatable/equatable.dart';

class PickLocationState extends Equatable {
  final bool loadingAddress;
  final String? address;

  const PickLocationState(
      {this.address,
      this.loadingAddress = false });

  PickLocationState copyWith({
    String? address,
    bool? loadingAddress,
  }) => PickLocationState(
      loadingAddress: loadingAddress ?? this.loadingAddress,
      address: address ?? this.address,
    );
    
      @override
      List<Object?> get props => [
        loadingAddress,
        address,
      ];
}
