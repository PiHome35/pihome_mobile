import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';

class CreateInviteCodeParams {
  final String token;
  const CreateInviteCodeParams({required this.token});
}

@injectable
class CreateInviteCodeUseCase implements UseCase<DataState<String>, CreateInviteCodeParams> {

  final FamilyRepository _familyRepository;
  const CreateInviteCodeUseCase(this._familyRepository);


  @override
  @override
  Future<DataState<String>> execute(CreateInviteCodeParams params) async {
    return _familyRepository.createFamilyInviteCode(token: params.token);
  }
}
