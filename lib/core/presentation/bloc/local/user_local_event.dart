import 'package:equatable/equatable.dart';

abstract class UserLocalEvent extends Equatable {
  const UserLocalEvent();

  @override
  List<Object> get props => [];
}

class GetCachedUserEvent extends UserLocalEvent {
  const GetCachedUserEvent();
}
