import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/error_handler.dart';
import 'package:caff_shop_app/app/api/interceptors/add_token_interceptor.dart';
import 'package:caff_shop_app/app/models/comment.dart';
import 'package:caff_shop_app/app/models/comment_request.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:caff_shop_app/app/models/response.dart';
import 'package:caff_shop_app/app/models/user.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'file_details_store.g.dart';

class FileDetailsStore = _FileDetailsStore with _$FileDetailsStore;

abstract class _FileDetailsStore with Store {
  final LoadingStore loadingStore = LoadingStore(
    loading: true,
  );

  _FileDetailsStore({
    required this.caff,
    required this.isAdmin,
  });

  // store variables:-----------------------------------------------------------
  @observable
  String text = "";

  @observable
  ObservableList<Comment> comments = ObservableList.of([]);

  @observable
  ObservableList<User> users = ObservableList.of([]);

  final ConvertedCaff caff;
  final bool isAdmin;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> init({
    required void Function(String, void Function()) onError,
  }) async {
    loadingStore.loading = true;

    try {
      Future.wait([
        getCaffDetails(),
        getAllUser(),
      ]);
    } on DioError catch (error) {
      handleDioError(
        error: error,
        onError: (message) => onError(message, () => init(onError: onError)),
      );
    }

    loadingStore.loading = false;
  }

  @action
  Future<void> getCaffDetails() async {
    Response<List<Comment>> response =
        await Api(interceptors: [AddTokenInterceptor()])
            .getCaffApi()
            .getAllComment(caff.id);

    if (response.isSuccess()) {
      comments.clear();
      comments.addAll(response.data!);
    }
  }

  @action
  Future<void> getAllUser() async {
    Response<List<User>> response =
        await Api(interceptors: [AddTokenInterceptor()]).getUserApi().getAll();

    if (response.isSuccess()) {
      users.clear();
      users.addAll(response.data!);
    }
  }

  @action
  Future<void> createComment({
    required String userId,
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      CommentRequest resource = CommentRequest(
        userId: userId,
        caffId: caff.id,
        text: text,
      );
      Response<Comment> response =
          await Api(interceptors: [AddTokenInterceptor()])
              .getCaffApi()
              .createComment(resource);

      if (response.isSuccess()) {
        comments.add(response.data!);
        text = "";
        onSuccess();
      }
    } on DioError catch (error) {
      handleDioError(
        error: error,
        onError: (message) => onError(message),
      );
    }

    loadingStore.stackedLoading = false;
  }

  @action
  Future<void> deleteComment({
    required String commentId,
    required void Function(MessageResponse) onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      Response<MessageResponse> response =
          await Api(interceptors: [AddTokenInterceptor()])
              .getCaffApi()
              .deleteCommentById(commentId);

      if (response.isSuccess()) {
        comments.removeWhere((e) => e.id == commentId);
        onSuccess(response.data!);
      }
    } on DioError catch (error) {
      handleDioError(
        error: error,
        onError: (message) => onError(message),
      );
    }

    loadingStore.stackedLoading = false;
  }

// general methods:-----------------------------------------------------------
}
