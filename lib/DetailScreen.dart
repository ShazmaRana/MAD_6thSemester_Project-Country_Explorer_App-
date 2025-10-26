import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> country;

  const DetailScreen({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // light grey background
      appBar: AppBar(
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          country['name']['common'],
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Flag Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SvgPicture.network(
                    country['flags']['svg'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow('Official Name', country['name']['official']),
                    _divider(),
                    _buildRow('Capital', (country['capital'] != null) ? country['capital'][0] : 'N/A'),
                    _divider(),
                    _buildRow('Population', '${country['population'].toString()}'),
                    _divider(),
                    _buildRow('Region', country['region'] ?? 'N/A'),
                    _divider(),
                    _buildRow('Subregion', country['subregion'] ?? 'N/A'),
                    _divider(),
                    _buildRow('Area', '${country['area']} km²'),
                    _divider(),
                    _buildRow('Languages', country['languages'] != null
                        ? country['languages'].values.join(', ')
                        : 'N/A'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(color: Colors.grey, thickness: 0.4);
  }
}
