import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:travelspots/repos/models/ui_models/relic_ui_model.dart';

/// RelicData Model
class RelicDataModel {
  /// id
  String id;

  /// Tên
  String ten;

  /// Cấp di tích
  int capDiTich;

  /// Loại di tích
  int loaiDiTich;

  /// Địa chỉ
  String diaChi;

  /// Quận
  String quan;

  /// Tỉnh thành
  String tinhThanh;

  /// Lat
  double lat;

  /// Long
  double long;

  /// Quyết định xếp hạng
  String quyetDinhXepHang;

  /// Mô tả
  String moTa;

  /// Ảnh
  String anh;

  RelicDataModel(
      {this.id,
      this.ten,
      this.capDiTich,
      this.loaiDiTich,
      this.diaChi,
      this.quan,
      this.tinhThanh,
      this.lat,
      this.long,
      this.quyetDinhXepHang,
      this.moTa,
      this.anh});

  /// Constructor RelicData Model

  factory RelicDataModel.fromDocument(DocumentSnapshot document) {
    Fimber.d('document data: ${document.data}');
    return RelicDataModel(
      id: document.documentID,
      ten: document['ten'],
      moTa: document['moTa'],
      diaChi: document['diaChi'],
    );
  }

  Map<String, dynamic> toJsonData() {
    return {
      'ten': ten,
      'capDiTich': capDiTich,
      'loaiDiTich': loaiDiTich,
      'diaChi': diaChi,
      'quan': quan,
      'tinhThanh': tinhThanh,
      'lat': lat,
      'long': long,
      'quyetDinhXepHang': quyetDinhXepHang,
      'moTa': moTa,
      'anh': anh,
    };
  }

  factory RelicDataModel.fromUI(RelicUIModel model) {
    return RelicDataModel(
      id: model.id,
      ten: model.name,
      moTa: model.description,
      diaChi: model.address,
    );
  }

  // for importing data
  factory RelicDataModel.fromGoogleJson(Map<String, dynamic> itemJson) {
    var id = itemJson['gsx\u0024id']['\u0024t'];
    var ten = itemJson['gsx\u0024ten']['\u0024t'];
    var capDiTich = itemJson['gsx\u0024capditich']['\u0024t'];
    var loaiDiTich = itemJson['gsx\u0024loaiditich']['\u0024t'];
    var diaChi = itemJson['gsx\u0024diachi']['\u0024t'];
    var quan = itemJson['gsx\u0024quan']['\u0024t'];
    var tinhThanh = itemJson['gsx\u0024tinhthanh']['\u0024t'];
    var lat = itemJson['gsx\u0024lat']['\u0024t'];
    var long = itemJson['gsx\u0024long']['\u0024t'];
    var quyetDinhXepHang = itemJson['gsx\u0024quyetdinhxephang']['\u0024t'];
    var moTa = itemJson['gsx\u0024mota']['\u0024t'];
    var anh = itemJson['gsx\u0024anh']['\u0024t'];
    print('id is: $id');
    print('ten is: $ten');
    print('capDiTich is: $capDiTich');
    print('loaiDiTich is: $loaiDiTich');
    print('diaChi is: $diaChi');
    print('quan is: $quan');
    print('tinhThanh is: $tinhThanh');
    print('lat is: $lat');
    print('long is: $long');
    print('quyetDinhXepHang is: $quyetDinhXepHang');
    print('moTa is: $moTa');
    print('anh is: $anh');

    return RelicDataModel(
      id: id,
      ten: ten,
      capDiTich: int.parse(capDiTich),
      loaiDiTich: int.parse(loaiDiTich),
      diaChi: diaChi,
      quan: quan,
      tinhThanh: tinhThanh,
      lat: double.parse(lat),
      long: double.parse(long),
      quyetDinhXepHang: quyetDinhXepHang,
      moTa: moTa,
      anh: anh,
    );
  }
}
