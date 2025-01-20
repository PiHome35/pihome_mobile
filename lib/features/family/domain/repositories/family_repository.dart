import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';

abstract class FamilyRepository {
  Future<DataState<FamilyEntity>> createFamily({
    required String name,
    required String token,
  });

  Future<DataState<FamilyEntity>> joinFamily({
    required String inviteCode,
    required String token,
  });
}
