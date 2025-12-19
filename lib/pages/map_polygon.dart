import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/widgets/google_maps_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPolygon extends StatefulWidget {
  const MapPolygon({super.key});

  @override
  State<MapPolygon> createState() => MapPolygonState();
}

class MapPolygonState extends State<MapPolygon> {
  LatLng? position;
  final Set<Polygon> _polygons = {};
  final List<LatLng> _points = [];
  final PolygonId _polygonId = const PolygonId('userPolygon');

  @override
  void initState() {
    super.initState();
    loadInitData();
  }

  void loadInitData() async {
    await getPolygon();
  }

  getInitPosition() async {
    try {
      final curposition = await MediaService().getLocation();
      final lat = curposition.position!.latitude;
      final long = curposition.position!.longitude;
      setState(() {
        position = LatLng(lat, long);
      });
      print("curposition => $position");
    } catch (error) {
      print("getCurPosition-error");
    }
  }

  _onMapTap(LatLng point) async {
    setState(() {
      _points.add(point);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("polygon point marked")));
    });
  }

  resetPolygon() {
    setState(() {
      _polygons.clear();
      _points.clear();
    });
  }

  drawPolygons() {
    setState(() {
      final List<LatLng> closedPoints = List<LatLng>.from(_points)
        ..add(_points.first);
      _polygons
        ..removeWhere((p) => p.polygonId == _polygonId)
        ..add(
          Polygon(
            polygonId: _polygonId,
            points: closedPoints,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.3),
            strokeWidth: 3,
            consumeTapEvents: false,
            geodesic: false,
            // onTap: _onPolygonTap
          ),
        );
    });
  }

  void savePolygon(polygon) async {
    try {
      final loadLocalDB = await SharedPreferences.getInstance();
      await loadLocalDB.setString('polygon_points', json.encode(_points));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(
              'Polygon points latitude and longitude saved successfully',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print("savePolygon-error $error");
    }
  }

  getPolygon() async {
    try {
      final asyncPrefs = await SharedPreferences.getInstance();
      String? polygonData = asyncPrefs.getString('polygon_points');
      if (polygonData != null) {
        final points = json.decode(polygonData);
        print("finally get Points $points");
        List<LatLng> pointsList =
            points.map<LatLng>((p) => LatLng(p[0], p[1])).toList();
        print("finally get pointsList $pointsList");
        if (pointsList.isNotEmpty) {
          position = pointsList[0];
          setState(() {
            _points.addAll(pointsList);
          });
          drawPolygons();
        } else {
          await getInitPosition();
        }
      } else {
        await getInitPosition();
      }
    } catch (error) {
      print("getPolygon-error $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child:
                position != null
                    ? GoogleMapsCard(
                      location: position!,
                      onMapTap: _onMapTap,
                      polygons: _polygons,
                    )
                    : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Map is Loading ...'),
                          SizedBox(width: 10),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    drawPolygons();
                  },
                  child: Text('Draw Polygons'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    resetPolygon();
                  },
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    savePolygon(_points);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
