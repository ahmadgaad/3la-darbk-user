import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoriesRepository categoriesRepository;
  CategoryCubit(this.categoriesRepository) : super(InitialState()){
    getCategories();
  }


  getCategories() async {
    emit(LoadingState());
    final result = await categoriesRepository.getCategories();
    result.fold(
      (list) => emit(SuccessState(list)),
      (exception) => emit(ErrorState()),
    );
  }
}
