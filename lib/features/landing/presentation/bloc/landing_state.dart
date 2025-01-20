import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class LandingState extends Equatable {
  final int currentIndex;

  const LandingState({
    this.currentIndex = 0,
  });

  LandingState copyWith({
    int? currentIndex,
  }) {
    return LandingState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}
