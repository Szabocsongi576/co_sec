import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final LoadingStore loadingStore = LoadingStore(
    loading: true,
  );

  // store variables:-----------------------------------------------------------
  @observable
  String name = "name";

  @observable
  String email = "email";

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getProfile() async {
    loadingStore.loading = true;

    await Future.delayed(Duration(milliseconds: 500));

    loadingStore.loading = false;
  }

  // general methods:-----------------------------------------------------------

}
