import 'package:mobile_pihome/core/domain/entities/user.dart';
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

  Future<DataState<String>> createFamilyInviteCode({
    required String token,
  });

  Future<DataState<void>> deleteInviteCode({
    required String token,
  });

  Future<DataState<List<UserEntity>>> getFamilyMembers({
    required String token,
  });

  Future<DataState<FamilyEntity?>> getFamilyDetail({
    required String token,
  });

  Future<DataState<FamilyEntity>> updateCurrentUserFamily({
    required String token,
    required String chatModelKey,
  });
}
