import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/graphql_data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/domain/repositories/chat_repository.dart';

class GetAllChatsParams {
  final String familyId;
  final String token;
  final int? limit;
  final int? offset;

  GetAllChatsParams({
    required this.familyId,
    required this.token,
    this.limit,
    this.offset,
  });
}

@injectable
class GetAllChatsUseCase
    implements UseCase<GraphqlDataState<List<ChatEntity>>, GetAllChatsParams> {
  final IChatRepository _repository;

  GetAllChatsUseCase(this._repository);

  @override
  Future<GraphqlDataState<List<ChatEntity>>> execute(GetAllChatsParams params) {
    return _repository.getAllChatsWithFamilyId(
      familyId: params.familyId,
      token: params.token,
      limit: params.limit,
      offset: params.offset,
    );
  }
}
