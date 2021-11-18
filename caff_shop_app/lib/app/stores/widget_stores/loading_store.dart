import 'package:mobx/mobx.dart';

part 'loading_store.g.dart';

class LoadingStore = _LoadingStore with _$LoadingStore;

abstract class _LoadingStore with Store {
  _LoadingStore({
    this.loading = false,
    this.stackedLoading = false,
  });

  // store variables:-----------------------------------------------------------
  @observable
  bool loading;

  @observable
  bool stackedLoading;
}
