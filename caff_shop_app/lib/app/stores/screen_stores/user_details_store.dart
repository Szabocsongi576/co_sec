import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/error_handler.dart';
import 'package:caff_shop_app/app/api/interceptors/add_token_interceptor.dart';
import 'package:caff_shop_app/app/models/response.dart';
import 'package:caff_shop_app/app/models/user.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'user_details_store.g.dart';

class UserDetailsStore = _UserDetailsStore with _$UserDetailsStore;

abstract class _UserDetailsStore with Store {
  final LoadingStore loadingStore = LoadingStore();

  _UserDetailsStore({required this.user});

  // store variables:-----------------------------------------------------------
  @observable
  User user;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> editUser({
    required User editedUser,
    required void Function(MessageResponse) onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      Response<MessageResponse> response =
      await Api(interceptors: [AddTokenInterceptor()])
          .getUserApi()
          .updateUserById(editedUser);

      if (response.isSuccess()) {
        Response<User> getUserResponse =
        await Api(interceptors: [AddTokenInterceptor()])
            .getUserApi()
            .getUserById(user.id);

        if (getUserResponse.isSuccess()) {
          user = getUserResponse.data!;
          onSuccess(response.data!);
        }
      }
    } on DioError catch (error) {
      await handleDioError(
        error: error,
        onError: onError,
        failedFunction: () => editUser(
          editedUser: editedUser,
          onSuccess: onSuccess,
          onError: onError,
        ),
      );
    }

    loadingStore.stackedLoading = false;
  }

  // general methods:-----------------------------------------------------------
}
