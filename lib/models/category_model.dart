class CategoryModel {
  String? type;
  Properties? properties;
  Geometry? geometry;

  CategoryModel({
    this.type,
    this.properties,
    this.geometry,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      type: json['type'] ?? '',
      properties: json['properties'] != null
          ? Properties.fromMap(json['properties'])
          : null,
      geometry:
          json['geometry'] != null ? Geometry.fromMap(json['geometry']) : null,
    );
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({
    this.type,
    this.coordinates,
  });

  factory Geometry.fromMap(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'] ?? '',
      coordinates:
          List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}

class Properties {
  String? name;
  String? country;
  String? countryCode;
  String? state;
  String? county;
  String? city;
  String? postcode;
  String? suburb;
  String? street;
  String? housenumber;
  String? iso31662;
  double? lon;
  double? lat;
  String? stateCode;
  String? formatted;
  String? addressLine1;
  String? addressLine2;
  List<String>? categories;
  List<String>? details;
  Datasource? datasource;
  Contact? contact;
  String? placeId;

  Properties({
    this.name,
    this.country,
    this.countryCode,
    this.state,
    this.county,
    this.city,
    this.postcode,
    this.suburb,
    this.street,
    this.housenumber,
    this.iso31662,
    this.lon,
    this.lat,
    this.stateCode,
    this.formatted,
    this.addressLine1,
    this.addressLine2,
    this.categories,
    this.details,
    this.datasource,
    this.contact,
    this.placeId,
  });

  factory Properties.fromMap(Map<String, dynamic> json) {
    return Properties(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      countryCode: json['country_code'] ?? '',
      state: json['state'] ?? '',
      county: json['county'] ?? '',
      city: json['city'] ?? '',
      postcode: json['postcode'] ?? '',
      suburb: json['suburb'] ?? '',
      street: json['street'] ?? '',
      housenumber: json['housenumber'] ?? '',
      iso31662: json['iso3166-2'] ?? '',
      lon: (json['lon'] != null) ? json['lon'].toDouble() : null,
      lat: (json['lat'] != null) ? json['lat'].toDouble() : null,
      stateCode: json['state_code'] ?? '',
      formatted: json['formatted'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      categories:
          (json['categories'] as List?)?.map((e) => e.toString()).toList(),
      details: (json['details'] as List?)?.map((e) => e.toString()).toList(),
      datasource: json['datasource'] != null
          ? Datasource.fromMap(json['datasource'])
          : null,
      contact:
          json['contact'] != null ? Contact.fromMap(json['contact']) : null,
      placeId: json['place_id'] ?? '',
    );
  }
}

class Contact {
  String? phone;

  Contact({
    this.phone,
  });

  factory Contact.fromMap(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'] ?? '',
    );
  }
}

class Datasource {
  String? sourcename;
  String? attribution;
  String? license;
  String? url;
  Raw? raw;

  Datasource({
    this.sourcename,
    this.attribution,
    this.license,
    this.url,
    this.raw,
  });

  factory Datasource.fromMap(Map<String, dynamic> json) {
    return Datasource(
      sourcename: json['sourcename'] ?? '',
      attribution: json['attribution'] ?? '',
      license: json['license'] ?? '',
      url: json['url'] ?? '',
      raw: json['raw'] != null ? Raw.fromMap(json['raw']) : null,
    );
  }
}

class Raw {
  String? name;
  String? phone;
  int? osmId;
  String? amenity;
  String? osmType;
  String? addrCity;
  String? emergency;
  String? healthcare;
  String? addrStreet;
  int? addrPostcode;
  int? addrHousenumber;
  String? healthcareSpeciality;

  Raw({
    this.name,
    this.phone,
    this.osmId,
    this.amenity,
    this.osmType,
    this.addrCity,
    this.emergency,
    this.healthcare,
    this.addrStreet,
    this.addrPostcode,
    this.addrHousenumber,
    this.healthcareSpeciality,
  });

  factory Raw.fromMap(Map<String, dynamic> json) {
    return Raw(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      osmId: json['osm_id'],
      amenity: json['amenity'] ?? '',
      osmType: json['osm_type'] ?? '',
      addrCity: json['addr_city'] ?? '',
      emergency: json['emergency'] ?? '',
      healthcare: json['healthcare'] ?? '',
      addrStreet: json['addr_street'] ?? '',
      addrPostcode: json['addr_postcode'],
      addrHousenumber: json['addr_housenumber'],
      healthcareSpeciality: json['healthcare_speciality'] ?? '',
    );
  }
}
