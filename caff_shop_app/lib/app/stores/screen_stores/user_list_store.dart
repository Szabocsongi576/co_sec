import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/error_handler.dart';
import 'package:caff_shop_app/app/api/interceptors/add_token_interceptor.dart';
import 'package:caff_shop_app/app/models/response.dart';
import 'package:caff_shop_app/app/models/user.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'user_list_store.g.dart';

class UserListStore = _UserListStore with _$UserListStore;

abstract class _UserListStore with Store {
  final LoadingStore loadingStore = LoadingStore();

  // store variables:-----------------------------------------------------------
  @observable
  String term = "";

  @observable
  bool focused = false;

  @observable
  bool empty = true;

  @observable
  ObservableList<User> userList = ObservableList.of([]);

  @observable
  ObservableList<User> filteredUserList = ObservableList.of([]);

  // actions:-------------------------------------------------------------------
  @action
  Future<void> getUsers({
    required void Function(String) onError,
  }) async {
      loadingStore.loading = true;

    try {
      Response<List<User>> response = await Api(interceptors: [AddTokenInterceptor()])
            .getUserApi()
            .getAll();

      if (response.isSuccess()) {
        userList.clear();
        userList.addAll(response.data!);
        filterUsers();
      }
    } on DioError catch (error) {
      await handleDioError(
        error: error,
        onError: onError,
        failedFunction: () => getUsers(
          onError: onError,
        ),
      );
    }

      loadingStore.loading = false;
  }

  @action
  Future<void> deleteUser({
    required String userId,
    required void Function(MessageResponse) onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      Response<MessageResponse> response =
      await Api(interceptors: [AddTokenInterceptor()])
          .getUserApi()
          .deleteUserById(userId);

      if (response.isSuccess()) {
        userList.removeWhere((e) => e.id == userId);
        filterUsers();
        onSuccess(response.data!);
      }
    } on DioError catch (error) {
      await handleDioError(
        error: error,
        onError: onError,
        failedFunction: () => deleteUser(
          userId: userId,
          onSuccess: onSuccess,
          onError: onError,
        ),
      );
    }

    loadingStore.stackedLoading = false;
  }

  void filterUsers() {
    filteredUserList.clear();
    if(term.isEmpty) {
      filteredUserList.addAll(userList);
    } else {
      if(term.length == 1) {
        userList.forEach((e) {
          if(e.username.toLowerCase().startsWith(term.toLowerCase())) {
            filteredUserList.add(e);
          }
        });
      } else {
        userList.forEach((e) {
          if(e.username.toLowerCase().contains(term.toLowerCase())) {
            filteredUserList.add(e);
          }
        });
      }
    }
  }
  // general methods:-----------------------------------------------------------
}
