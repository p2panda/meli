// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

enum ExpandDirection { left, right }

@immutable
class ExpandableFab extends StatefulWidget {
  final Icon icon;
  final ExpandDirection expandDirection;
  final double distance;
  final Color color;
  final List<ActionButton> buttons;

  const ExpandableFab(
      {super.key,
      required this.distance,
      required this.buttons,
      required this.color,
      required this.expandDirection,
      required this.icon});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alignment = (widget.expandDirection == ExpandDirection.left)
        ? Alignment.bottomRight
        : Alignment.bottomLeft;
    return SizedBox(
      height: 120,
      width: 160,
      child: SizedBox.expand(
          child: Stack(
        alignment: alignment,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      )),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          color: MeliColors.white,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: MeliColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.buttons.length;
    final step = 90.0 / (count - 1);
    final degrees =
        (widget.expandDirection == ExpandDirection.left) ? 90.0 : 0.0;
    for (var i = 0, angleInDegrees = degrees;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          expandDirection: widget.expandDirection,
          child: _buildActionButton(widget.buttons[i], _toggle),
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            foregroundColor: Colors.black,
            backgroundColor: widget.color,
            shape: const CircleBorder(),
            onPressed: _toggle,
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    this.expandDirection = ExpandDirection.right,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;
  final ExpandDirection expandDirection;

  @override
  Widget build(BuildContext context) {
    final leftPosition =
        (expandDirection == ExpandDirection.right) ? 4.0 : null;
    final rightPosition =
        (expandDirection == ExpandDirection.left) ? 4.0 : null;
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          left: (leftPosition != null) ? leftPosition + offset.dx : null,
          right: (rightPosition != null) ? rightPosition + offset.dx : null,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: GestureDetector(
            onTap: () {
              // Do nothing
            },
            behavior: HitTestBehavior.deferToChild,
            child: child),
      ),
    );
  }
}

class ActionButton {
  final Icon icon;
  final Function onPressed;
  final Color color;

  ActionButton(
      {required this.icon, required this.onPressed, required this.color});
}

Widget _buildActionButton(ActionButton actionButton, Function toggle) {
  return Material(
    elevation: 5,
    shape: const CircleBorder(),
    color: actionButton.color,
    clipBehavior: Clip.antiAlias,
    child: IconButton(
      onPressed: () {
        actionButton.onPressed();
        toggle();
      },
      icon: actionButton.icon,
      color: Colors.black,
    ),
  );
}

@immutable
class ExpandableFabItem extends StatelessWidget {
  const ExpandableFabItem({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      height: isBig ? 128 : 36,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
