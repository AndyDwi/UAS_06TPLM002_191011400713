import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(UASAndyApp());
}

class UASAndyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS Andy',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _cityName = '';
  double _temperature = 0.0;
  String _dateTime = '';
  String _weatherCondition = '';

  final String _apiKey = '8a279d2d3301175e89e866dd2c90039e';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  void _getWeatherData() async {
    if (_cityName.isEmpty) return;

    final String apiUrl = '$_baseUrl?q=$_cityName&appid=$_apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _temperature = jsonData['main']['temp'];
        _weatherCondition = jsonData['weather'][0]['main'];

        // Ambil waktu saat ini
        var now = DateTime.now();
        // Format waktu ke dalam bentuk yang sesuai
        var formatter = DateFormat('EEE, d MMM y');
        _dateTime = formatter.format(now);
      });
    } else {
      setState(() {
        _temperature = 0.0;
        _dateTime = '';
        _weatherCondition = '';
      });
    }
  }

  String _getBackgroundImage() {
    if (_weatherCondition.isEmpty) {
      return 'images/default_background.jpg';
    }

    switch (_weatherCondition.toLowerCase()) {
      case 'clear':
        return 'images/clear_sky.jpg';
      case 'images/clouds':
        return 'cloudy.jpg';
      case 'rain':
        return 'rainy.jpg';
      case 'snow':
        return 'snowy.jpg';
      default:
        return 'default_background.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImage = _getBackgroundImage();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuaca di Kota'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$backgroundImage'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _cityName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Masukkan Nama Kota',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _getWeatherData();
              },
              child: Text('Cari'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Cuaca di $_cityName:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              _dateTime,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              _temperature == 0.0 ? 'Data tidak ditemukan' : '$_temperature °C',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
