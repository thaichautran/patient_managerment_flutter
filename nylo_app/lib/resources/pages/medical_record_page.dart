import 'package:flutter/material.dart';
import 'package:flutter_app/app/database/database_service.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MedicalRecordPage extends StatefulWidget {
  final int patientId;
  MedicalRecordPage({super.key, required this.patientId});

  @override
  _MedicalRecordPageState createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends NyState<MedicalRecordPage> {
  ApiService _apiService = ApiService();

  // final List<MedicalRecords> medicalRecords;
  Patient _patient = Patient();
  init() async {
    Patient? patient = await _apiService.getPatientById(id: widget.patientId);
    if (patient != null) {
      _patient = patient;
      print(_patient.medicalRecords?[0].benhnhanId);
      int s = await DatabaseHelper.updatePatient(_patient);
      print(s);
    } else {
      _patient = (await DatabaseHelper.getPatient(widget.patientId))!;
      print(_patient.medicalRecords);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phiếu khám bệnh của ${widget.patientId}'),
      ),
      body: Center(
        child:
            _patient.medicalRecords == null || _patient.medicalRecords!.isEmpty
                ? Text('Không có phiếu khám bệnh')
                : ListView.builder(
                    itemCount: _patient.medicalRecords!.length,
                    itemBuilder: (context, index) {
                      final record = _patient.medicalRecords![index];
                      return Column(
                        children: [
                          Text('chiều cao: ${record.chieucao}'),
                          Text('Cân nặng: ${record.cannang}'),
                          Text('Tiền sử: ${record.tiensu}'),
                          Text('Lâm sàng: ${record.lamsang}'),
                          Text('Mạch: ${record.mach}'),
                          Text('Nhiệt độ: ${record.nhietdo}'),
                          Text('Huyết áp cao: ${record.huyetapcao}'),
                          Text('Huyết áp thấp: ${record.huyetapthap}'),
                          Text('Mô tả: ${record.mota}'),
                          Text('Chuẩn đoán: ${record.chuandoan}'),
                          Divider(),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
