import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../exceptions/exceptions.dart';

abstract class BaseUseCase<T, Parameters> {
  Future<Either<AppException, T>> call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();

  @override
  List<Object> get props => [];
}
