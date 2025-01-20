import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'landing_event.dart';
import 'landing_state.dart';

@injectable
class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(const LandingState()) {
    on<TabChanged>(_onTabChanged);
  }

  void _onTabChanged(TabChanged event, Emitter<LandingState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }
}
