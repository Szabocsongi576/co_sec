import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final LoadingStore loadingStore = LoadingStore();

  // store variables:-----------------------------------------------------------

  // actions:-------------------------------------------------------------------
  @action
  Future<void> logout({
    required void Function() onSuccess,
  }) async {
    loadingStore.stackedLoading = true;

    await Future.delayed(Duration(milliseconds: 500));
    ApiUtil().reset();
    onSuccess();

    loadingStore.stackedLoading = false;
  }

  // general methods:-----------------------------------------------------------
}
