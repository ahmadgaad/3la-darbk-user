
import 'package:equatable/equatable.dart';

import '../../repositories/models/category_model.dart';

sealed class CategoryState extends Equatable {}

final class InitialState extends CategoryState {
  @override
  List<Object?> get props => [];
}

final class LoadingState extends CategoryState {
  @override
  List<Object?> get props => [];
}

final class ErrorState extends CategoryState {
  @override
  List<Object?> get props => [];
}

final class SuccessState extends CategoryState {
  final List<CategoryModel> categories;

  SuccessState(this.categories);
  
  @override
  List<Object?> get props => [
    categories,
  ];
}
