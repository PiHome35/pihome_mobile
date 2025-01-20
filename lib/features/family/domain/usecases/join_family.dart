import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';

class JoinFamilyParams {
  final String inviteCode;
  final String token;

  JoinFamilyParams({
    required this.inviteCode,
    required this.token,
  });
}

@injectable
class JoinFamilyUseCase implements UseCase<DataState<FamilyEntity>, JoinFamilyParams> {
  final FamilyRepository _familyRepository;

  JoinFamilyUseCase(this._familyRepository);

  @override
  Future<DataState<FamilyEntity>> execute(JoinFamilyParams params) async {
    return _familyRepository.joinFamily(inviteCode: params.inviteCode, token: params.token);
  }
}
