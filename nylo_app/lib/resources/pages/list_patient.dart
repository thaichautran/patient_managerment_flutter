import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/resources/pages/add_patient.dart';
import 'package:flutter_app/resources/pages/detail_page.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/login_page.dart';

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
                Auth.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              }
            },
          ),
        ],
      ),
      body: _listPatient.isEmpty
          ? Center(
              child: Text("Không có bệnh nhân nào!"),
            )
          : ListView.builder(
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
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
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  String selectedDates = selectedDate.toString();
                  _apiService.fetchPatient(selectedDates, 1, 50).then(
                    (patients) {
                      if (patients != null) {
                        setState(() {
                          _listPatient = patients;
                        });
                      }
                    },
                  );
                }
              });
            },
            child: Icon(Icons.calendar_today),
          ),
        ],
      ),
    );
  }
}
