class CategoryModel {
  String type;
  Properties properties;
  Geometry geometry;

  CategoryModel({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      type: json['type'],
      properties: Properties.fromMap(json['properties']),
      geometry: Geometry.fromMap(json['geometry']),
    );
  }
}

class Geometry {
  String type;
  List<double> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });
  factory Geometry.fromMap(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
  
}

class Properties {
  String name;
  String country;
  String countryCode;
  String state;
  String county;
  String city;
  String postcode;
  String suburb;
  String street;
  String housenumber;
  String iso31662;
  double lon;
  double lat;
  String stateCode;
  String formatted;
  String addressLine1;
  String addressLine2;
  List<String> categories;
  List<String> details;
  Datasource datasource;
  Contact contact;
  String placeId;

  Properties({
    required this.name,
    required this.country,
    required this.countryCode,
    required this.state,
    required this.county,
    required this.city,
    required this.postcode,
    required this.suburb,
    required this.street,
    required this.housenumber,
    required this.iso31662,
    required this.lon,
    required this.lat,
    required this.stateCode,
    required this.formatted,
    required this.addressLine1,
    required this.addressLine2,
    required this.categories,
    required this.details,
    required this.datasource,
    required this.contact,
    required this.placeId,
  });
  factory Properties.fromMap(Map<String, dynamic> json) {
    return Properties(
      name: json['name'],
      country: json['country'],
      countryCode: json['country_code'],
      state: json['state'],
      county: json['county'],
      city: json['city'],
      postcode: json['postcode'],
      suburb: json['suburb'],
      street: json['street'],
      housenumber: json['housenumber'],
      iso31662: json['iso3166-2'],
      lon: json['lon'].toDouble(),
      lat: json['lat'].toDouble(),
      stateCode: json['state_code'],
      formatted: json['formatted'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      categories: List<String>.from(json['categories']),
      details: List<String>.from(json['details']),
      datasource: Datasource.fromMap(json['datasource']),
      contact: Contact.fromMap(json['contact']),
      placeId: json['place_id'],
    );
  }
}

class Contact {
  String phone;

  Contact({
    required this.phone,
  });

  factory Contact.fromMap(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
    );
  }
}

class Datasource {
  String sourcename;
  String attribution;
  String license;
  String url;
  Raw raw;

  Datasource({
    required this.sourcename,
    required this.attribution,
    required this.license,
    required this.url,
    required this.raw,
  });

  factory Datasource.fromMap(Map<String, dynamic> json) {
    return Datasource(
      sourcename: json['sourcename'],
      attribution: json['attribution'],
      license: json['license'],
      url: json['url'],
      raw: Raw.fromMap(json['raw']),
    );
  }
}

class Raw {
  String name;
  String phone;
  int osmId;
  String amenity;
  String osmType;
  String addrCity;
  String emergency;
  String healthcare;
  String addrStreet;
  int addrPostcode;
  int addrHousenumber;
  String healthcareSpeciality;

  Raw({
    required this.name,
    required this.phone,
    required this.osmId,
    required this.amenity,
    required this.osmType,
    required this.addrCity,
    required this.emergency,
    required this.healthcare,
    required this.addrStreet,
    required this.addrPostcode,
    required this.addrHousenumber,
    required this.healthcareSpeciality,
  });

  factory Raw.fromMap(Map<String, dynamic> json) {
    return Raw(
      name: json['name'],
      phone: json['phone'],
      osmId: json['osm_id'],
      amenity: json['amenity'],
      osmType: json['osm_type'],
      addrCity: json['addr_city'],
      emergency: json['emergency'],
      healthcare: json['healthcare'],
      addrStreet: json['addr_street'],
      addrPostcode: json['addr_postcode'],
      addrHousenumber: json['addr_housenumber'],
      healthcareSpeciality: json['healthcare_speciality'],
    );
  }
}