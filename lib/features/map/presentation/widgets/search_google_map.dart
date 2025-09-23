import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/config/style/app_color.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../repositories/map_repo.dart';
import '../../repositories/models/suggestion_model.dart';

class AddressSearch extends SearchDelegate<SuggestionModel> {
  final LatLng _position;

  AddressSearch(this._position, this._mapRepo,);

  final MapRepo _mapRepo;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear,color: AppColors.black,),
        onPressed: () {
          query = '';
        },
      )
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: AppColors.black,
      ),
      onPressed: () {
        close(context, SuggestionModel('', ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : _mapRepo.fetchSuggestions(query, context.languageCode,
              _position.latitude, _position.longitude),
      builder: (context, snapshot) => query == ''
          ? Container()
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(
                      (snapshot.data![index]).description,
                      style: AppTextStyle.font14black500,
                    ),
                    onTap: () {
                      close(context, snapshot.data![index]);
                    },
                  ),
                  itemCount: snapshot.data?.length,
                )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
