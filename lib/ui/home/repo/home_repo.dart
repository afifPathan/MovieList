import 'package:webclues_practical/ui/home/ds/home_api_ds.dart';
import 'package:webclues_practical/ui/home/entity/now_playing.dart';

class HomeRepo {
  final _homeApiDS = HomeApiDS();

  Stream<NowPlaying> getMovieData(int page, String query) {
    return _homeApiDS.getMovieDataDs(page,query);
  }
}
