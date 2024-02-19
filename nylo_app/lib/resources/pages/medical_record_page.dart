import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MedicalRecordPage extends StatefulWidget {
  final int patientId;
  final List<MedicalRecords> medicalRecords;
  MedicalRecordPage(
      {super.key, required this.patientId, required this.medicalRecords});

  @override
  _MedicalRecordPageState createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends NyState<MedicalRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phiếu khám bệnh của ${widget.patientId}'),
      ),
      body: Center(
        child: widget.medicalRecords == null || widget.medicalRecords.isEmpty
            ? Text('Không có phiếu khám bệnh')
            : ListView.builder(
                itemCount: widget.medicalRecords.length,
                itemBuilder: (context, index) {
                  final record = widget.medicalRecords[index];
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
