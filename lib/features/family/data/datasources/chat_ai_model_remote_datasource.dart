import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/config/config_path.dart';
import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/features/family/data/models/chat_ai_model.dart';
import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';

abstract class ChatAiModelRemoteDataSource {
  Future<List<ChatAiModel>> getChatAiModels({required String token});
}

@LazySingleton(as: ChatAiModelRemoteDataSource)
class ChatAiModelRemoteDataSourceImpl extends ChatAiModelRemoteDataSource {
  final Dio _dio;

  ChatAiModelRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ChatAiModel>> getChatAiModels({required String token}) async {
    try {
      final response = await _dio.get(
        getChatAiModelsUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        log('[ChatAiModelRemoteDataSourceImpl] getChatAiModels data: $data');
        List<ChatAiModel> chatAiModels = [];
        for (var item in data['chatModels']) {
          chatAiModels.add(ChatAiModel.fromJson(item));
        }
        return chatAiModels;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
