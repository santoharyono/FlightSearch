import 'package:flight_search/multi_city_input.dart';
import 'package:flight_search/price_tab.dart';
import 'package:flutter/material.dart';

class ContentCard extends StatefulWidget {
  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool showInput = true;
  bool showInputTabOptions = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: DefaultTabController(
          length: 3,
          child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraint) {
            return Column(
              children: <Widget>[
                _buildTabBar(),
                _buildContentContainer(viewportConstraint)
              ],
            );
          })),
    );
  }

  Widget _buildTabBar({bool showFirstOption}) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: Container(
          height: 2.0,
          color: Color(0xFFEEEEEE),
        )),
        TabBar(
          tabs: [
            Tab(
              text: showInputTabOptions ? 'Flight' : 'Price',
            ),
            Tab(
              text: showInputTabOptions ? 'Train' : 'Duration',
            ),
            Tab(
              text: showInputTabOptions ? 'Bus' : 'Stops',
            )
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildContentContainer(BoxConstraints viewportConstraints) {
    return Expanded(
        child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight - 48.0),
        child: IntrinsicHeight(
          child: showInput
              ? _buildMulticityTab()
              : PriceTab(
                  height: viewportConstraints.maxHeight - 48.0,
                  onPlaneFlightStart: (() => showInputTabOptions = false),
                ),
        ),
      ),
    ));
  }

  Widget _buildMulticityTab() {
    return Column(children: <Widget>[
      Expanded(child: MultiCityInput()),
      Padding(
        padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              showInput = false;
            });
          },
          child: Icon(
            Icons.timeline,
            size: 36.0,
          ),
        ),
      )
    ]);
  }
}
