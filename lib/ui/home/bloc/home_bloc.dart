import 'package:rxdart/rxdart.dart';
import 'package:webclues_practical/network/view_state.dart';
import 'package:webclues_practical/ui/base/base_bloc.dart';
import 'package:webclues_practical/ui/home/entity/movie_data.dart';
import 'package:webclues_practical/ui/home/entity/now_playing.dart';
import 'package:webclues_practical/ui/home/repo/home_repo.dart';
import 'package:webclues_practical/ui/home/states/list_data_state.dart';

class HomeBloc extends BaseBloc {
  HomeRepo _homeRepo = HomeRepo();
  final viewState = PublishSubject<ViewState>();

  final listDataState = BehaviorSubject<ListDataState>();

  final listData = BehaviorSubject<NowPlaying>();
  final movieListData = BehaviorSubject<MovieData>();

  void getData({int page = 1, bool clear = false, String query=''}) {
    subscription.add(_homeRepo
        .getMovieData(page,query)
        .map((data) => ListDataState.completed(data, isLoadingMore: page > 1))
        .onErrorReturnWith(
            (error) => ListDataState.error(error, isLoadingMore: page > 1))
        .startWith(ListDataState.loading(isLoadingMore: page > 1))
        .listen((state) {
      print('////// State: $state');
      listDataState.add(state);
      if (state.isCompleted()) {
        final newList = state.data.movies ?? List();
        final currentList = movieListData.value?.movies ?? List();
        final data = state.data;

        if (state.data.page == 1) {
          if(clear == false){
            currentList.clear();
          }
        }
        currentList.addAll(newList);
  
        var movieData = MovieData(
            page: state.data.page,
            totalPages: state.data.totalPages,
            totalResults: state.data.totalResults,
            movies: currentList);

        listData.add(data);
        movieListData.add(movieData);
      }
    }));
  }

  void loadMore(String query) {
    if(movieListData.value?.totalPages==movieListData.value?.page){
      getData(page: (1), clear: (true), query: (query));
    }
    else{
      getData(page: (listData.value?.page ?? 1) + 1, query: (query));
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewState?.close();
  }
}
