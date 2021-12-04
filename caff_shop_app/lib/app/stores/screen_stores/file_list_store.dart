import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/error_handler.dart';
import 'package:caff_shop_app/app/api/interceptors/add_token_interceptor.dart';
import 'package:caff_shop_app/app/models/caff_request.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:caff_shop_app/app/models/response.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'file_list_store.g.dart';

class FileListStore = _FileListStore with _$FileListStore;

abstract class _FileListStore with Store {
  final LoadingStore loadingStore = LoadingStore(
    loading: true,
  );

  _FileListStore({
    required this.isAdmin,
  });

  // store variables:-----------------------------------------------------------
  @observable
  ObservableList<ConvertedCaff> caffList = ObservableList.of([]);

  final bool isAdmin;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getCaffFiles({
    required void Function(String) onError,
  }) async {
    loadingStore.loading = true;

    try {
      Response<List<ConvertedCaff>> response =
      await Api(interceptors: [AddTokenInterceptor()])
          .getCaffApi()
          .getAll();

      if (response.isSuccess()) {
        caffList.clear();
        caffList.addAll(response.data!);
      }
    } on DioError catch (error) {
      handleDioError(
        error: error,
        onError: onError,
      );
    }

    loadingStore.loading = false;
  }

  @action
  Future<void> createCaff({
    required String userId,
    required CaffRequest resource,
    required void Function(MessageResponse) onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      Response<MessageResponse> response =
      await Api(interceptors: [AddTokenInterceptor()])
          .getUserApi()
          .createCaff(userId, resource);

      if (response.isSuccess()) {
        onSuccess(response.data!);
      }
    } on DioError catch (error) {
      handleDioError(
        error: error,
        onError: onError,
      );
    }

    loadingStore.stackedLoading = false;
  }

  @action
  Future<void> deleteCaff({
    required String caffId,
    required void Function(MessageResponse) onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      Response<MessageResponse> response =
      await Api(interceptors: [AddTokenInterceptor()])
          .getCaffApi()
          .deleteCaffById(caffId);

      if (response.isSuccess()) {
        caffList.removeWhere((e) => e.id == caffId);
        onSuccess(response.data!);
      }
    } on DioError catch (error) {
      handleDioError(
        error: error,
        onError: onError,
      );
    }

    loadingStore.stackedLoading = false;
  }

  // general methods:-----------------------------------------------------------
}
