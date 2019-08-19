import 'package:flutter/material.dart';

class MultiCityInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.flight_takeoff,
                    color: Colors.red,
                  ),
                  labelText: 'From'),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.flight_land,
                              color: Colors.red,
                            ),
                            labelText: 'To'),
                      ))),
              Container(
                width: 64.0,
                alignment: Alignment.center,
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  labelText: 'Passengers'),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.date_range,
                  color: Colors.red,
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Departure'),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Arrival'),
                ),
              ))
            ],
          )
        ],
      ),
    ));
  }
}
