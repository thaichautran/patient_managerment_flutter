import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/resources/pages/add_patient.dart';
import 'package:flutter_app/resources/pages/detail_page.dart';
import 'package:flutter_app/resources/pages/home_page.dart';

import 'package:nylo_framework/nylo_framework.dart';

class ListPatientPage extends StatefulWidget {
  @override
  _ListPatientPageState createState() => _ListPatientPageState();
}

class _ListPatientPageState extends NyState<ListPatientPage> {
  ApiService _apiService = ApiService();
  List<Patient> _listPatient = [];
  @override
  init() async {
    DateTime now = DateTime.now();
    String nowAsString = now.toString();
    List<Patient>? patients =
        await _apiService.fetchPatient(nowAsString, 1, 50);
    if (patients != null) {
      setState(() {
        _listPatient = patients;
      });
    }
    print(_listPatient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bệnh nhân'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final status = await api<ApiService>(
                  (service) => service.logout(),
                  context: context);
              if (status == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _listPatient.length,
        itemBuilder: (context, index) {
          final patient = _listPatient[index];
          return ListTile(
            title: Text(patient.hovaten ?? ""),
            subtitle: Text(patient.namsinh.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(patient: patient),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPatientForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
