import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/patient.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/resources/pages/get_location.dart';
import 'package:flutter_app/resources/pages/list_patient.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AddPatientForm extends StatefulWidget {
  final String address;

  const AddPatientForm({super.key, required this.address});
  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends NyState<AddPatientForm> {
  final _formKey = GlobalKey<FormState>();

  displayToast(bool status) {
    showToast(
        title: status ? "Thành công!" : "Thất bại!",
        description: status
            ? "Thêm bệnh nhân thành công"
            : "Đã xảy ra lỗi khi thêm bệnh nhân",
        icon: Icons.account_circle,
        duration: Duration(seconds: 2),
        style: status
            ? ToastNotificationStyleType.SUCCESS
            : ToastNotificationStyleType
                .DANGER // SUCCESS, INFO, DANGER, WARNING
        );
  }

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
  String _tienSu = 'Không bị bệnh gì cả';
  String _lamSang = 'Không biết';
  String _mach = '80';
  String _nhietDo = '37';
  String _huyetApCao = '140';
  String _huyetApThap = '112';
  String _teBao = 'Không biết';
  int _mauChay = 12;
  String _moTa = 'Hay bị viêm họng mỗi khi trời lạnh';
  String _chuanDoan = 'Viêm họng cấp';
  String _dieuTri = 'Uống thuốc kháng sinh và giữ ấm cơ thể';
  String _hinhAnh1 = '';
  String _hinhAnh2 = '';

  MedicalRecords? _medicalRecord;
  List<String> _hinhAnh = [];
  final ImagePicker _imagePicker = ImagePicker();
  List<File> _files = [];

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
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetLocationPage(),
                        ),
                      );
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
                onSaved: (value) {
                  value != null ? _diaChi = value : _diaChi = widget.address;
                },
                initialValue: widget.address,
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
                  _gioiTinh = value!;
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
              Builder(
                builder: (context) {
                  return Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Wrap(
                          runSpacing: 10.0,
                          spacing: -15,
                          children: _files.map((e) {
                            return fileRow(e, () {
                              setState(() {
                                _files.remove(e);
                              });
                            });
                          }).toList(),
                        ),
                      )
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        // Navigator.of(context).pop();
                        final XFile? file = await _imagePicker.pickImage(
                            source: ImageSource.camera);
                        if (file != null) {
                          setState(() {
                            _files.add(File(file.path));
                          });
                        }
                      },
                      child: Icon(Icons.camera_alt),
                      shape: CircleBorder(),
                      mini: true,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        final XFile? file = await _imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            _files.add(File(file.path));
                          });
                        }
                      },
                      child: Icon(Icons.folder),
                      shape: CircleBorder(),
                      mini: true,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  var _image = '';
                  if (_files.isNotEmpty) {
                    _image = await api<ApiService>(
                        (service) => service.uploadImage(files: _files),
                        context: context);
                    print(_image);
                  }
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
                      hinhanh1: _image,
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
                      displayToast(true);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListPatientPage(),
                        ),
                      );
                    } else {
                      displayToast(false);
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

Widget fileRow(File file, VoidCallback onPress) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              Image.file(
                file,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: -10,
                right: 15,
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.red,
                  onPressed: onPress,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
