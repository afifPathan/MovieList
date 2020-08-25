import 'package:flutter/material.dart';
import 'package:webclues_practical/colors.dart';
import 'package:webclues_practical/network/app_exception.dart';
import 'package:webclues_practical/ui/base/base_stateful_widget.dart';
import 'package:webclues_practical/ui/home/bloc/home_bloc.dart';
import 'package:webclues_practical/ui/home/entity/movie.dart';
import 'package:webclues_practical/ui/home/entity/movie_data.dart'; 
import 'package:webclues_practical/ui/home/states/list_data_state.dart';
import 'package:webclues_practical/ui/home/tiles/movie_list_tile.dart';
import 'package:webclues_practical/widgets/custom_loader.dart';
import 'package:webclues_practical/widgets/error_view.dart';
import 'package:webclues_practical/widgets/pagination_wrapper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseStatefulWidgetState<HomePage> {
  final _homeBloc = HomeBloc();
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    "WebClues Practical",
    style: new TextStyle(color: Colors.white),
  );
  final TextEditingController _searchQuery = new TextEditingController();

  _HomePageState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        _homeBloc.getData(query: '');
      } else {
        _homeBloc.getData(query: _searchQuery.text);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _homeBloc.getData();
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text("WebClues Practical",
          style: new TextStyle(color: Colors.white));
      _searchQuery.clear();
    });
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: actionIcon,
        onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                autofocus: true,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Find here...",
                    hintStyle: new TextStyle(
                        color: colorBlackGradient90, fontSize: 20.0)),
              );
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBar(context),
      backgroundColor: colorGrayscale10,
      body: StreamBuilder<ListDataState>(
          stream: _homeBloc.listDataState,
          builder: (context, snapshot) {
            final state = snapshot.data;
            final isLoadingMore = state?.isLoadingMore ?? false;

            if ((state?.isLoading() ?? true) && !isLoadingMore) {
              return CustomLoader();
            }

            if (state.isError()) {
              return Center(
                child: ErrorView(
                  content: state.error?.toString(),
                  retryVisible: (state.error is NoInternetException),
                  onPressed: () {
                    _homeBloc.getData();
                  },
                ),
              );
            }

            return StreamBuilder<MovieData>(
                stream: _homeBloc.movieListData,
                initialData: _homeBloc.movieListData.value,
                builder: (context, snapshot) {
                  final items = snapshot.data?.movies ?? List();

                  if (state.isCompleted() &&
                      items.isEmpty &&
                      !state.isLoadingMore)
                    return Center(
                      child: ErrorView(
                        content: state.error?.toString(),
                        retryVisible: false,
                      ),
                    );

                  return PaginationWrapper(
                    onLoadMore: () {
                      _homeBloc.loadMore(_searchQuery.text);
                    },
                    isLoading: state.isLoading(),
                    isEndReached: false,
                    scrollableChild: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        _movieList(items),
                      ],
                    )),
                  );
                });
          }),
    );
  }

  Widget _movieList(List<Movie> movieList) {
    return Container(
      height: MediaQuery.of(context).size.height - 90,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          if (position == movieList.length) {
            return CustomLoader();
          }
          Movie movie = movieList[position];
          return MovieListViewTile(movie);
        },
        itemCount: movieList.length + 1,
      ),
    );
  }
}
