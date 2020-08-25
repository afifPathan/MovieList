import 'package:webclues_practical/ui/base/base_ui_state.dart';
import 'package:webclues_practical/ui/home/entity/now_playing.dart';

class ListDataState extends BaseUiState<NowPlaying> {
  var isLoadingMore = false;

  ListDataState();

  /// Loading state
  ListDataState.loading({this.isLoadingMore}) : super.loading();

  /// Completed state
  ListDataState.completed(NowPlaying movie,{this.isLoadingMore}) : super.completed(data: movie);

  /// Error state
  ListDataState.error(dynamic exception,{this.isLoadingMore}) : super.error(exception);
}
