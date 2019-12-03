import 'package:travelspots/repos/models/ui_models/spot_ui_model.dart';

/// RelicData Model
class SpotDataModel {
  /// id
  int id;

  // Unique key, is the combination of spreadsheetId + worksheetId
  String uniqueKey;

  /// Name
  String name;

  /// Popularity
  int popularity;

  /// Address
  String address;

  /// District
  String district;

  /// District key
  String districtKey;

  /// Province
  String province;

  /// Lat
  double lat;

  /// Long
  double long;

  /// Location Link
  String locationLink;

  /// Description
  String description;

  /// Website
  String website;

  /// Image link
  String imageLink;

  SpotDataModel({
    this.id,
    this.uniqueKey,
    this.name,
    this.popularity,
    this.address,
    this.district,
    this.districtKey,
    this.province,
    this.lat,
    this.long,
    this.locationLink,
    this.description,
    this.website,
    this.imageLink,
  });

  /// Constructor RelicData Model

//  factory SpotDataModel.fromDocument(DocumentSnapshot document) {
//    Fimber.d('document data: ${document.data}');
//    return SpotDataModel(
//      id: document.documentID as int,
//      name: document['name'],
//      popularity: document['popularity'],
//      address: document['address'],
//      district: document['district'],
//      districtKey: document['district_key'],
//      lat: document['lat'],
//      long: document['long'],
//      description: document['description'],
//      website: document['website'],
//      imageLink: document['image_link'],
//    );
//  }

//  Map<String, dynamic> toJsonData() {
//    return {
//      'name': name,
//      'uniqueKey': uniqueKey,
//      'popularity': popularity,
//      'address': address,
//      'district': district,
//      'district_key': districtKey,
//      'province': province,
//      'lat': lat,
//      'long': long,
//      'description': description,
//      'website': website,
//      'image_link': imageLink,
//    };
//  }

  factory SpotDataModel.fromUI(SpotUIModel model) {
    return SpotDataModel(
      id: model.id,
      name: model.name,
      address: model.address,
      description: model.description,
      district: model.district,
    );
  }

  // for importing data
  factory SpotDataModel.fromGoogleJson(
      Map<String, dynamic> itemJson, String uniqueKey, String province) {
    var id = itemJson['gsx\u0024id']['\u0024t'];
    var name = itemJson['gsx\u0024name']['\u0024t'];
    var popularity = itemJson['gsx\u0024popularity']['\u0024t'];
    var address = itemJson['gsx\u0024address']['\u0024t'];
    var district = itemJson['gsx\u0024district']['\u0024t'];
    var districtKey = itemJson['gsx\u0024districtkey']['\u0024t'];
    var lat = itemJson['gsx\u0024lat']['\u0024t'];
    var long = itemJson['gsx\u0024long']['\u0024t'];
    var locationLink = itemJson['gsx\u0024locationlink']['\u0024t'];
    var description = itemJson['gsx\u0024description']['\u0024t'];
    var website = itemJson['gsx\u0024website']['\u0024t'];
    var imageLink = itemJson['gsx\u0024imagelink']['\u0024t'];
    print('id is: $id');
    print('name is: $name');
    print('popularity is: $popularity');
    print('address is: $address');
    print('district is: $district');
    print('districtKey is: $districtKey');
    print('lat is: $lat');
    print('long is: $long');
    print('locationLink is: $locationLink');
    print('description is: $description');
    print('website is: $website');
    print('imageLink is: $imageLink');
    print('uniqueKey is: $uniqueKey');

    return SpotDataModel(
      id: id,
      uniqueKey: uniqueKey,
      name: name,
      popularity: int.parse(popularity == '' ? '3' : popularity),
      address: address,
      district: district,
      districtKey: districtKey,
      lat: double.parse(lat == '' ? '10.7771437' : lat),
      long: double.parse(long == '' ? '106.6954479' : long),
      locationLink: locationLink,
      description: description,
      website: website,
      imageLink: imageLink,
    );
  }
}
