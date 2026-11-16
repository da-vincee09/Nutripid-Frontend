import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Creates a reusable page transitions for GoRouter navigation.
CustomTransitionPage<void> buildPageWithTransition({
  // Provides information about the current widget's location in the widget tree.
  required BuildContext context,

  // Contains information about the current route or page.
  required GoRouterState state,

  // The screen or widget that will be displayed.
  required Widget child,

  // Sets the type of transition, with slide from right as the default.
  TransitionType type = TransitionType.slideFromRight,

  // Sets the animation duration to 300 milliseconds by default.
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage<void>(
    // Gives the page a unique key for route identification.
    key: state.pageKey,

    // Sets the screen that will appear during the transition.
    child: child,

    // Controls how long the forward transition takes.
    transitionDuration: duration,

    // Controls how long the reverse transition takes.
    reverseTransitionDuration: duration,

    // Defines how the page will animate when opening or closing.
    // animation – Controls the animation of the page that is currently entering or leaving.
    // secondaryAnimation – Controls the animation of the other page involved in the transition, usually the page underneath or behind it.
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Selects the animation based on the chosen transition type.
      switch (type) {

        case TransitionType.slideFromRight:
          // Slides the page into view from the right side.
          return SlideTransition(
            // Defines the starting and ending positions of the slide.
            position: Tween<Offset>( // Tween tells Flutter where an animation should start and where it should finish.
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              // Uses the page animation to control the movement.
              parent: animation,
              // Makes the animation start fast and slow down smoothly.
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );

        case TransitionType.slideFromBottom:
          // Slides the page into view from the bottom
          return SlideTransition(
            // Defines the starting and endng positions of the slide.
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              // Uses the page animation to control the movement.
              parent: animation,
              // Makes the animation start fast and slow down smoothly.
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );

        case TransitionType.fade:
          // Makes the page gradually appear or disappear.
          return FadeTransition(opacity: animation, child: child);

        case TransitionType.none:
          // Displays the page without an animation.
          return child;
      }
    },
  );
}

// Defines the available page transition animation styles.
enum TransitionType {
  slideFromRight,
  slideFromBottom,
  fade,
  none,
}