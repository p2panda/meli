// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class MeliExpansionTile extends StatefulWidget {
  final Widget header;
  final Widget child;
  final EdgeInsetsGeometry childrenPadding;
  final ValueChanged<bool>? onExpansionChanged;

  const MeliExpansionTile({
    super.key,
    required this.header,
    required this.child,
    this.onExpansionChanged,
    this.childrenPadding =
        const EdgeInsets.only(top: 5.0, right: 8.0, bottom: 8.0, left: 8.0),
  });

  @override
  State<MeliExpansionTile> createState() => MeliExpansionTileState();
}

class MeliExpansionTileState extends State<MeliExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late AnimationController _controller;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void expandedChanged(bool isExpanded) {
    _setExpanded(isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then((_) {
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context).writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    }
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: _handleTap,
          child: widget.header,
        ),
        ClipRect(
          child: Align(
            alignment: Alignment.topLeft,
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding,
          child: widget.child,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
