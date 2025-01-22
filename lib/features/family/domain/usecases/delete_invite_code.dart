import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';

class DeleteInviteCodeParams {
  const DeleteInviteCodeParams({
    required this.token,
  });
  final String token;
}

@injectable
class DeleteInviteCodeUseCase
    implements UseCase<DataState<void>, DeleteInviteCodeParams> {
  DeleteInviteCodeUseCase(this._repository);
  final FamilyRepository _repository;

  @override
  Future<DataState<void>> execute(DeleteInviteCodeParams params) async {
    return _repository.deleteInviteCode(token: params.token);
  }
}
