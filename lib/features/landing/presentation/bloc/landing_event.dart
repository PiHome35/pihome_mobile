import 'package:flutter/material.dart';

@immutable
sealed class LandingEvent {
  const LandingEvent();
}

final class TabChanged extends LandingEvent {
  final int index;

  const TabChanged(this.index);
}
