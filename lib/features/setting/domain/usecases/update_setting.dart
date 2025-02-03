import 'dart:developer';

import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/core/usecase/usecase.dart';
import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';
import 'package:mobile_pihome/features/family/domain/repositories/family_repository.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/domain/repositories/setting_repository.dart';
import 'package:injectable/injectable.dart';

class UpdateSettingParams {
  final String token;
  final String chatModelKey;

  UpdateSettingParams({
    required this.token,
    required this.chatModelKey,
  });
}

@injectable
class UpdateSettingUseCase
    implements UseCase<DataState<FamilyEntity>, UpdateSettingParams> {
  // final SettingRepository _repository;
  final FamilyRepository _familyRepository;

  UpdateSettingUseCase(this._familyRepository);

  @override
  Future<DataState<FamilyEntity>> execute(UpdateSettingParams params) async {
    log('UpdateSettingUseCase execute: ${params.chatModelKey}');
    return await _familyRepository.updateCurrentUserFamily(
      token: params.token,
      chatModelKey: params.chatModelKey,
    );
  }
}
