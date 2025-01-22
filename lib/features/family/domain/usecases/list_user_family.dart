import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';

class ListUserFamilyParams {
  final String token;

  ListUserFamilyParams({required this.token});
}

@injectable
class ListUserFamilyUseCase implements UseCase<DataState<List<UserEntity>>, ListUserFamilyParams> {
  final FamilyRepository _familyRepository;

  ListUserFamilyUseCase(this._familyRepository);

  @override
  Future<DataState<List<UserEntity>>> execute(ListUserFamilyParams params) async {
    return await _familyRepository.getFamilyMembers(token: params.token);
  }
}