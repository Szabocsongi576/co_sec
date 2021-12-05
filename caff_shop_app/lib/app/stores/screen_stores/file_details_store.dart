import 'dart:typed_data';

import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/error_handler.dart';
import 'package:caff_shop_app/app/api/interceptors/add_token_interceptor.dart';
import 'package:caff_shop_app/app/models/comment.dart';
import 'package:caff_shop_app/app/models/comment_request.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:caff_shop_app/app/models/response.dart';
import 'package:caff_shop_app/app/services/save_file_service.dart';
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

  final ConvertedCaff caff;
  final bool isAdmin;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> init({
    required void Function(String, void Function()) onError,
  }) async {
    loadingStore.loading = true;

    try {
      Response<List<Comment>> response =
      await Api(interceptors: [AddTokenInterceptor()])
          .getCaffApi()
          .getAllComment(caff.id);

      if (response.isSuccess()) {
        comments.clear();
        comments.addAll(response.data!);
      }
    } on DioError catch (error) {
      await handleDioError(
        error: error,
        onError: (message) => onError(message, () => init(onError: onError)),
        failedFunction: () => init(
          onError: onError,
        ),
      );
    }

    loadingStore.loading = false;
  }

  @action
  Future<void> createComment({
    required String userId,
    required String username,
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      CommentRequest resource = CommentRequest(
        userId: userId,
        caffId: caff.id,
        username: username,
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
      await handleDioError(
        error: error,
        onError: (message) => onError(message),
        failedFunction: () => createComment(
          userId: userId,
          username: username,
          onSuccess: onSuccess,
          onError: onError,
        ),
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
      await handleDioError(
        error: error,
        onError: (message) => onError(message),
        failedFunction: () => deleteComment(
          commentId: commentId,
          onSuccess: onSuccess,
          onError: onError,
        ),
      );
    }

    loadingStore.stackedLoading = false;
  }

  @action
  Future<void> downloadCaff({
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    loadingStore.stackedLoading = true;

    try {
      Response<Uint8List> response =
          await Api(interceptors: [AddTokenInterceptor()])
              .getCaffApi()
              .downloadCaffById(caff.id);

      if (response.isSuccess()) {
        await SaveFileService().saveCaff(response.data!, caff.name);
        onSuccess();
      }
    } on DioError catch (error) {
      await handleDioError(
        error: error,
        onError: (message) => onError(message),
        failedFunction: () => downloadCaff(
          onSuccess: onSuccess,
          onError: onError,
        ),
      );
    }

    loadingStore.stackedLoading = false;
  }

// general methods:-----------------------------------------------------------
}
