import 'package:rxdart/rxdart.dart';
import 'package:webclues_practical/network/api_manager.dart';
import 'package:webclues_practical/network/view_state.dart';

class BaseBloc {
  final isApiCallInProgress = PublishSubject<bool>();

  ApiManager _apiManager = ApiManager();
  CompositeSubscription subscription = CompositeSubscription();

  Stream<ViewState<T>> handleAPICall<T>(Stream source, {customResponse}) {
    return _apiManager.callApi<T>(source, customResponse: customResponse);
  }

  void dispose() {
    subscription.clear();
    isApiCallInProgress.close();
  }
}
