import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

class GetAllChatsParams {
  final String familyId;
  final String token;
  final int? limit;
  final int? skip;

  GetAllChatsParams({
    required this.familyId,
    required this.token,
    this.limit,
    this.skip,
  });
}

@injectable
class GetAllChatsUseCase implements UseCase<GraphqlDataState<List<ChatEntity>>, GetAllChatsParams> {
  final IChatRepository _chatRepository;

  GetAllChatsUseCase(this._chatRepository);

  @override
  Future<GraphqlDataState<List<ChatEntity>>> execute(
    GetAllChatsParams params,
  ) async {
    return _chatRepository.getAllChatsWithFamilyId(
      familyId: params.familyId,
      token: params.token,
      limit: params.limit,
      offset: params.skip,
    );
  }
}
