import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/resources/pages/list_patient.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AddPatientForm extends StatefulWidget {
  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final _formKey = GlobalKey<FormState>();

  String _hoVaTen = '';
  int _soCon = 0;
  int _namSinh = 0;
  String _soHoSo = '';
  String _diaChi = '';
  String _gioiTinh = '';
  String _ngheNghiep = '';
  String _ngayTao = '';
  String _ngayKetThuc = '';

  String _canNang = '68';
  String _chieuCao = '168';
  String _tienSu = '';
  String _lamSang = '';
  String _mach = '';
  String _nhietDo = '';
  String _huyetApCao = '';
  String _huyetApThap = '';
  String _teBao = '';
  int _mauChay = 0;
  String _moTa = 'ddau dau';
  String _chuanDoan = '';
  String _dieuTri = '';
  String _hinhAnh1 = '';
  String _hinhAnh2 = '';

  MedicalRecords? _medicalRecord;
  List<String> _hinhAnh = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm bệnh nhân'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Họ và tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
                onSaved: (value) {
                  _hoVaTen = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Số con'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số con';
                  }
                  return null;
                },
                onSaved: (value) {
                  _soCon = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Năm sinh'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập năm sinh';
                  }
                  return null;
                },
                onSaved: (value) {
                  _namSinh = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Số hồ sơ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số hồ sơ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _soHoSo = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
                onSaved: (value) {
                  _diaChi = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Giới tính'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giới tính';
                  }
                  return null;
                },
                onSaved: (value) {
                  _diaChi = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nghề nghiệp'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nghề nghiệp';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ngheNghiep = value!;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  _ngayTao = DateTime.now().toString();
                  _ngayKetThuc = DateTime.now().toString();
                  _medicalRecord = MedicalRecords(
                      id: 0,
                      benhnhanId: 0,
                      chieucao: _chieuCao,
                      cannang: _canNang,
                      tiensu: _tienSu,
                      lamsang: _lamSang,
                      mach: _mach,
                      nhietdo: _nhietDo,
                      huyetapcao: _huyetApCao,
                      huyetapthap: _huyetApThap,
                      tebao: _teBao,
                      mauchay: _mauChay,
                      mota: _moTa,
                      chuandoan: _chuanDoan,
                      dieutri: _dieuTri,
                      hinhanh1: _hinhAnh1,
                      hinhanh2: _hinhAnh2,
                      benhNhan: null,
                      hinhanh: []);
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final status = await api<ApiService>(
                        (service) => service.addPatient(
                              hovaten: _hoVaTen,
                              socon: _soCon,
                              namsinh: _namSinh,
                              sohoso: _soHoSo,
                              diachi: _diaChi,
                              gioitinh: _gioiTinh,
                              nghenghiep: _ngheNghiep,
                              ngaytao: _ngayTao,
                              ngayketthuc: _ngayKetThuc,
                              medicalRecords: _medicalRecord,
                              hinhanh: _hinhAnh,
                            ),
                        context: context);
                    if (status == 200) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListPatientPage(),
                        ),
                      );
                    }
                  }
                },
                child: Text('Thêm bệnh nhân'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
