import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';

import 'package:qr_reader_app/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'org';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (tipoMapa == 'org') {
          tipoMapa = 'fr/osmfr';
        } else if (tipoMapa == 'fr/osmfr') {
          tipoMapa = 'fr/hot';
        } else if (tipoMapa == 'fr/hot') {
          tipoMapa = 'de';
        } else {
          tipoMapa = 'org';
        }
        setState(() {});
      },
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://{s}.tile.openstreetmap.$tipoMapa/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c'],
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        new Marker(
          width: 50.0,
          height: 50.0,
          point: scan.getLatLng(),
          builder: (context) => new Container(
            child: Icon(
              Icons.location_on,
              size: 50.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
