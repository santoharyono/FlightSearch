import 'package:flight_search/animated_dot.dart';
import 'package:flight_search/animated_plane_icon.dart';
import 'package:flight_search/flight_stop.dart';
import 'package:flight_search/flight_stop_card.dart';
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
  final List<GlobalKey<FlightStopCardState>> _stopKeys = [];
  AnimationController _fabAnimationController;
  Animation _fabAnimation;

  final List<FlightStop> _flightStops = [
    FlightStop("JFK", "ORY", "JUN 05", "6h 25m", "\$851", "9:26 am - 3:43 pm"),
    FlightStop("MRG", "FTB", "JUN 20", "6h 25m", "\$532", "9:26 am - 3:43 pm"),
    FlightStop("ERT", "TVS", "JUN 20", "6h 25m", "\$718", "9:26 am - 3:43 pm"),
    FlightStop("KKR", "RTY", "JUN 20", "6h 25m", "\$663", "9:26 am - 3:43 pm"),
  ];
  final double _cardHeight = 80.0;

  AnimationController _planeSizeAnimationController;
  AnimationController _planeTravelController;
  AnimationController _dotsAnimationController;
  List<Animation<double>> _dotPositions = [];
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
    _flightStops
        .forEach((stop) => _stopKeys.add(GlobalKey<FlightStopCardState>()));
    _initFabAnimationController();
    _initSizeAnimations();
    _initPlaneTravelAnimations();
    _initDotAnimationController();
    _initDotAnimations();
    _planeSizeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildPlane()]
          ..addAll(_flightStops.map(_buildStopCard))
          ..addAll(_flightStops.map(_mapFlightStopToDot))
          ..add(_buildFab()),
      ),
    );
  }

  Widget _buildFab() {
    return Positioned(
      bottom: 16.0,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.check,
            size: 36.0,
          ),
        ),
      ),
    );
  }

  Widget _mapFlightStopToDot(stop) {
    int index = _flightStops.indexOf(stop);
    bool isStartOrEnd = index == 0 || index == _flightStops.length - 1;
    Color color = isStartOrEnd ? Colors.red : Colors.green;
    return AnimatedDot(animation: _dotPositions[index], color: color);
  }

  Widget _buildPlane() {
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
            height: _flightStops.length * _cardHeight * 0.8,
            color: Color.fromARGB(255, 200, 200, 200),
          )
        ],
      ),
    );
  }

  Widget _buildStopCard(FlightStop stop) {
    int index = _flightStops.indexOf(stop);
    double topMargin = _dotPositions[index].value -
        0.5 * (FlightStopCard.height - AnimatedDot.size);
    bool isLeft = index.isOdd;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLeft ? Container() : Expanded(child: Container()),
            Expanded(
                child: FlightStopCard(
              key: _stopKeys[index],
              isLeft: isLeft,
              flightStop: stop,
            )),
            !isLeft
                ? Container()
                : Expanded(
                    child: Container(),
                  )
          ],
        ),
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
              Future.delayed(Duration(milliseconds: 700), () {
                _dotsAnimationController.forward();
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

  _animateFab() {
    _fabAnimationController.forward();
  }

  Future _animateFlightStopCards() async {
    return Future.forEach(_stopKeys, (GlobalKey<FlightStopCardState> stopKey) {
      return Future.delayed(Duration(microseconds: 250), () {
        stopKey.currentState.runAnimation();
      });
    });
  }

  void _initDotAnimations() {
    final double slideDurationInterval = 0.4;
    final double slideDelayInterval = 0.2;
    double startingMarginTop = widget.height;
    double minMarginTop =
        _minPlanePaddingTop + _planeSize + 0.5 * (0.8 * _cardHeight);

    for (int i = 0; i < _flightStops.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      double finalMarginTop = minMarginTop + i * (0.8 * _cardHeight);
      Animation<double> animation =
          Tween(begin: startingMarginTop, end: finalMarginTop).animate(
              CurvedAnimation(
                  parent: _dotsAnimationController,
                  curve: Interval(start, end, curve: Curves.easeOut)));
      _dotPositions.add(animation);
    }
  }

  void _initDotAnimationController() {
    _dotsAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animateFlightStopCards().then((_) => _animateFab());
            }
          });
  }

  void _initFabAnimationController() {
    _fabAnimationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));
    _fabAnimation =
        CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _planeSizeAnimationController.dispose();
    _planeTravelController.dispose();
    _dotsAnimationController.dispose();
    super.dispose();
  }
}
