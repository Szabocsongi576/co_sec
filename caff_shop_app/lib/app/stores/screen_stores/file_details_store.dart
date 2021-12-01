import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:mobx/mobx.dart';

part 'file_details_store.g.dart';

class FileDetailsStore = _FileDetailsStore with _$FileDetailsStore;

abstract class _FileDetailsStore with Store {
  final LoadingStore loadingStore = LoadingStore(
    loading: true,
  );

  // store variables:-----------------------------------------------------------
  @observable
  String? caffFile;

  @observable
  List<String> comments = [];

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getCaffDetails({
    required String id,
  }) async {
    loadingStore.loading = true;

    await Future.delayed(Duration(milliseconds: 500));
    comments.add("1 Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",);
    comments.add("2 Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",);
    comments.add("3 Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",);

    loadingStore.loading = false;
  }

  // general methods:-----------------------------------------------------------
}
