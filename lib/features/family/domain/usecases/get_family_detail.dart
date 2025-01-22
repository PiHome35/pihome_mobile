import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';

@injectable
class GetFamilyDetailUseCase implements UseCase<DataState<FamilyEntity?>, String> {
  final FamilyRepository _familyRepository;

  GetFamilyDetailUseCase(this._familyRepository);

  @override
  Future<DataState<FamilyEntity?>> execute(String token) async {
    return await _familyRepository.getFamilyDetail(token: token);
  }
}