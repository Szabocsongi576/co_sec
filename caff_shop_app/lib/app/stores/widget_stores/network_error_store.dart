import 'package:caff_shop_app/app/services/connectivity_service.dart';
import 'package:mobx/mobx.dart';

part 'network_error_store.g.dart';

class NetworkErrorStore = _NetworkErrorStore with _$NetworkErrorStore;

abstract class _NetworkErrorStore with Store {
  // store variables:-----------------------------------------------------------
  @observable
  String? errorMessage;

  Function? failedFunction;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> onRefresh() async {
    if(await ConnectivityService.checkConnectivity()) {
      errorMessage = null;
      if(failedFunction != null) {
        failedFunction!();
      }
    }
  }
}