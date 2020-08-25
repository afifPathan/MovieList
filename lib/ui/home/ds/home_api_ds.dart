import 'package:dio/dio.dart';
import 'package:webclues_practical/network/client/api_client.dart';
import 'package:webclues_practical/network/rest_constants.dart';
import 'package:webclues_practical/ui/home/entity/now_playing.dart';

class HomeApiDS {
  Stream<NowPlaying> getMovieDataDs(int page, String query) {
    String url = '';
    if (query.isEmpty) {
      url = RestConstants.GET_NOW_PLAYING_URL + "${page.toString()}";
    } else {
      url = RestConstants.GET_SEARCH_URL +
          "${page.toString()}" +
          RestConstants.query +
          query;
    }
    return ApiClient()
        .dio()
        .get(url, options: Options(headers: {ApiClient.REQUIRES_HEADER: false}))
        .asStream()
        .map((response) => nowPlayingFromJson(response.data));
  }
}
