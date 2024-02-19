class Patient {
  int? id;
  String? hovaten;
  int? socon;
  int? namsinh;
  String? sohoso;
  String? diachi;
  String? gioitinh;
  String? nghenghiep;
  String? ngaytao;
  String? ngayketthuc;
  int? tuoi;
  List<MedicalRecords>? medicalRecords;

  Patient(
      {this.id,
      this.hovaten,
      this.socon,
      this.namsinh,
      this.sohoso,
      this.diachi,
      this.gioitinh,
      this.nghenghiep,
      this.ngaytao,
      this.ngayketthuc,
      this.tuoi,
      this.medicalRecords});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hovaten = json['hovaten'];
    socon = json['socon'];
    namsinh = json['namsinh'];
    sohoso = json['sohoso'];
    diachi = json['diachi'];
    gioitinh = json['gioitinh'];
    nghenghiep = json['nghenghiep'];
    ngaytao = json['ngaytao'];
    ngayketthuc = json['ngayketthuc'];
    tuoi = json['tuoi'];
    if (json['medicalRecords'] != null) {
      medicalRecords = <MedicalRecords>[];
      json['medicalRecords'].forEach((v) {
        medicalRecords!.add(new MedicalRecords.fromJson(v));
      });
    } else {
      medicalRecords = <MedicalRecords>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hovaten'] = this.hovaten;
    data['socon'] = this.socon;
    data['namsinh'] = this.namsinh;
    data['sohoso'] = this.sohoso;
    data['diachi'] = this.diachi;
    data['gioitinh'] = this.gioitinh;
    data['nghenghiep'] = this.nghenghiep;
    data['ngaytao'] = this.ngaytao;
    data['ngayketthuc'] = this.ngayketthuc;
    data['tuoi'] = this.tuoi;
    (data['medicalRecords'] ?? []) as List;
    return data;
  }
}

class MedicalRecords {
  int? id;
  int? benhnhanId;
  String? cannang;
  String? chieucao;
  String? tiensu;
  String? lamsang;
  String? mach;
  String? nhietdo;
  String? huyetapcao;
  String? huyetapthap;
  String? tebao;
  int? mauchay;
  String? mota;
  String? chuandoan;
  String? dieutri;
  String? hinhanh1;
  String? hinhanh2;
  Patient? benhNhan;
  List<String>? hinhanh;

  MedicalRecords(
      {this.id,
      this.benhnhanId,
      this.cannang,
      this.chieucao,
      this.tiensu,
      this.lamsang,
      this.mach,
      this.nhietdo,
      this.huyetapcao,
      this.huyetapthap,
      this.tebao,
      this.mauchay,
      this.mota,
      this.chuandoan,
      this.dieutri,
      this.hinhanh1,
      this.hinhanh2,
      this.benhNhan,
      this.hinhanh});

  MedicalRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    benhnhanId = json['benhnhan_id'];
    cannang = json['cannang'];
    chieucao = json['chieucao'];
    tiensu = json['tiensu'];
    lamsang = json['lamsang'];
    mach = json['mach'];
    nhietdo = json['nhietdo'];
    huyetapcao = json['huyetapcao'];
    huyetapthap = json['huyetapthap'];
    tebao = json['tebao'];
    mauchay = json['mauchay'];
    mota = json['mota'];
    chuandoan = json['chuandoan'];
    dieutri = json['dieutri'];
    hinhanh1 = json['hinhanh1'];
    hinhanh2 = json['hinhanh2'];
    benhNhan = json['benhNhan'];
    if (json['hinhanh'] != null) {
      hinhanh = <String>[];
      json['hinhanh'].forEach((v) {
        hinhanh!.add(v.toString());
      });
    } else {
      hinhanh = <String>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['benhnhan_id'] = this.benhnhanId;
    data['cannang'] = this.cannang;
    data['chieucao'] = this.chieucao;
    data['tiensu'] = this.tiensu;
    data['lamsang'] = this.lamsang;
    data['mach'] = this.mach;
    data['nhietdo'] = this.nhietdo;
    data['huyetapcao'] = this.huyetapcao;
    data['huyetapthap'] = this.huyetapthap;
    data['tebao'] = this.tebao;
    data['mauchay'] = this.mauchay;
    data['mota'] = this.mota;
    data['chuandoan'] = this.chuandoan;
    data['dieutri'] = this.dieutri;
    data['hinhanh1'] = this.hinhanh1;
    data['hinhanh2'] = this.hinhanh2;
    data['benhNhan'] = this.benhNhan;
    if (this.hinhanh != null) {
      data['hinhanh'] = this.hinhanh!.map((v) => v).toList();
    } else {
      data['hinhanh'] = [];
    }
    return data;
  }
}
