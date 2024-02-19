import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:flutter_app/resources/pages/medical_record_page.dart';

class DetailPage extends StatelessWidget {
  final Patient patient;

  const DetailPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin bệnh nhân ${patient.id}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tên: ${patient.hovaten}'),
            Text('Năm sinh: ${patient.namsinh}'),
            Text('Số hồ sơ: ${patient.sohoso}'),
            Text('Địa chỉ: ${patient.diachi}'),
            Text('Giới tính: ${patient.gioitinh}'),
            Text('Nghề nghiệp: ${patient.nghenghiep}'),
            Text('Tuổi: ${patient.tuoi}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicalRecordPage(
                        patientId: patient.id!,
                        medicalRecords: patient.medicalRecords ?? []),
                  ),
                );
              },
              child: Text('Xem phiếu khám bệnh'),
            ),
          ],
        ),
      ),
    );
  }
}
