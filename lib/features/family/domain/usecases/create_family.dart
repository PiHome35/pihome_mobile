import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';

class CreateFamilyParams {
  final String name;
  final String token;

  CreateFamilyParams({required this.name, required this.token});
}

@injectable
class CreateFamilyUseCase
    implements UseCase<DataState<FamilyEntity>, CreateFamilyParams> {
  final FamilyRepository repository;

  CreateFamilyUseCase(this.repository);

  @override
  Future<DataState<FamilyEntity>> execute(CreateFamilyParams params) async {
    return await repository.createFamily(
      name: params.name,
      token: params.token,
    );
  }
}
