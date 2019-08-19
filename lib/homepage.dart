import 'package:flight_search/content_card.dart';
import 'package:flight_search/rounded_button.dart';
import 'package:flight_search/upper_bar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          UpperBar(
            height: 210.0,
          ),
          Positioned.fill(
              child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40.0),
            child: Column(
              children: <Widget>[
                _buildButtonRow(),
                Expanded(child: ContentCard())
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildButtonRow() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          RoundedButton(
            text: 'ONE WAY',
          ),
          RoundedButton(
            text: 'ROUND',
          ),
          RoundedButton(
            text: 'MULTICITY',
            selected: true,
          )
        ],
      ),
    );
  }
}
