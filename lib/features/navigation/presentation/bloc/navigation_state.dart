import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class NavigationState extends Equatable {
  final int currentIndex;
  final PageController pageController;

  const NavigationState({
    required this.currentIndex,
    required this.pageController,
  });

  @override
  List<Object?> get props => [currentIndex, pageController];
}
