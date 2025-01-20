import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/domain/usecases/get_cached_user.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/get_setting.dart';
import 'package:mobile_pihome/features/setting/domain/usecases/update_setting.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';

@injectable
class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final GetSettingUseCase _getSettingUseCase;
  final UpdateSettingUseCase _updateSettingUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;
  
  SettingBloc(
    this._getSettingUseCase,
    this._updateSettingUseCase,
    this._getCachedUserUseCase,
  ) : super(const SettingInitial()) {
    on<GetSettingEvent>(_onGetSetting);
    on<UpdateSettingEvent>(_onUpdateSetting);
  }

  Future<void> _onGetSetting(
      GetSettingEvent event, Emitter<SettingState> emit) async {
    emit(const SettingLoading());
    final result = await _getSettingUseCase.execute(null);
    emit(SettingLoaded(result));
  }

  Future<void> _onUpdateSetting(
      UpdateSettingEvent event, Emitter<SettingState> emit) async {
    emit(const SettingLoading());
    final result = await _updateSettingUseCase.execute(event.setting);

    emit(SettingLoaded(result));
  }
}
