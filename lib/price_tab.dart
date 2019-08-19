import 'package:flight_search/animated_plane_icon.dart';
import 'package:flutter/material.dart';

class PriceTab extends StatefulWidget {
  final double height;
  final VoidCallback onPlaneFlightStart;

  PriceTab({Key key, this.height, this.onPlaneFlightStart}) : super(key: key);

  @override
  _PriceTabState createState() => _PriceTabState();
}

class _PriceTabState extends State<PriceTab> with TickerProviderStateMixin {
  final double _initialPlanePaddingBottom = 16.0;
  final double _minPlanePaddingTop = 16.0;

  AnimationController _planeSizeAnimationController;
  AnimationController _planeTravelController;
  Animation _planeSizeAnimation;
  Animation _planeTravelAnimation;

  double get _planeTopPadding =>
      _minPlanePaddingTop +
      (1 - _planeTravelAnimation.value) * _maxPlaneTopPadding;
  double get _maxPlaneTopPadding =>
      widget.height - _initialPlanePaddingBottom - _planeSize;
  double get _planeSize => _planeSizeAnimation.value;

  @override
  void initState() {
    super.initState();
    _initSizeAnimations();
    _initPlaneTravelAnimations();
    _planeSizeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()],
      ),
    );
  }

  Widget _buildPlane() {
//    return Positioned(
//      top: _planeTopPadding,
//      child: Column(
//        children: <Widget>[
//          AnimatedPlaneIcon(
//            animation: _planeSizeAnimation,
//          )
//        ],
//      ),
//    );
    return AnimatedBuilder(
      animation: _planeTravelAnimation,
      builder: (context, child) => Positioned(
        child: child,
        top: _planeTopPadding,
      ),
      child: Column(
        children: <Widget>[
          AnimatedPlaneIcon(
            animation: _planeSizeAnimation,
          ),
          Container(
            width: 2.0,
            height: 240.0,
            color: Color.fromARGB(255, 200, 200, 200),
          )
        ],
      ),
    );
  }

  _initSizeAnimations() {
    _planeSizeAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 340))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Future.delayed(Duration(milliseconds: 500), () {
                widget?.onPlaneFlightStart();
                _planeTravelController.forward();
              });
            }
          });
    _planeSizeAnimation = Tween(begin: 60.0, end: 36.0).animate(CurvedAnimation(
        parent: _planeSizeAnimationController, curve: Curves.easeOut));
  }

  _initPlaneTravelAnimations() {
    _planeTravelController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _planeTravelAnimation = CurvedAnimation(
        parent: _planeTravelController, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    super.dispose();
  }
}
