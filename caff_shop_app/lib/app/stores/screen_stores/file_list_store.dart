import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:mobx/mobx.dart';

part 'file_list_store.g.dart';

class FileListStore = _FileListStore with _$FileListStore;

abstract class _FileListStore with Store {
  final LoadingStore loadingStore = LoadingStore(
    loading: true,
  );

  // store variables:-----------------------------------------------------------
  @observable
  ObservableList<String> caffSrcList = ObservableList.of([]);

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getCaffFiles({
    required void Function(String) onError,
  }) async {
    loadingStore.loading = true;

    await Future.delayed(Duration(milliseconds: 500));
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');
    caffSrcList.add('https://via.placeholder.com/150');

    loadingStore.loading = false;
  }

  // general methods:-----------------------------------------------------------

}
