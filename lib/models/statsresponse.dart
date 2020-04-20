class StatsResponse {
  bool error;
  int statusCode;
  String message;
  ResData data;

  StatsResponse({this.error, this.statusCode, this.message, this.data});

  StatsResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new ResData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ResData {
  String lastChecked;
  List<Covid19Stats> covid19Stats;

  ResData({this.lastChecked, this.covid19Stats});

  ResData.fromJson(Map<String, dynamic> json) {
    lastChecked = json['lastChecked'];
    if (json['covid19Stats'] != null) {
      covid19Stats = new List<Covid19Stats>();
      json['covid19Stats'].forEach((v) {
        covid19Stats.add(new Covid19Stats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastChecked'] = this.lastChecked;
    if (this.covid19Stats != null) {
      data['covid19Stats'] = this.covid19Stats.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Covid19Stats {
  String city;
  String province;
  String country;
  String lastUpdate;
  String keyId;
  int confirmed;
  int deaths;
  int recovered;

  Covid19Stats(
      {this.city,
      this.province,
      this.country,
      this.lastUpdate,
      this.keyId,
      this.confirmed,
      this.deaths,
      this.recovered});

  Covid19Stats.fromJson(Map<String, dynamic> json) {
    city = json['city'] != null ? json['city'] : "";
    province = json['province'] != null ? json['province'] : "";
    country = json['country'] != null ? json['country'] : "";
    lastUpdate = json['lastUpdate'] != null ? json['lastUpdate'] : "";
    keyId = json['keyId'] != null ? json['keyId'] : "";
    confirmed = json['confirmed'] != null ? json['confirmed'] : 0;
    deaths = json['deaths'] != null ? json['deaths'] : 0;
    recovered = json['recovered'] != null ? json['recovered'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['province'] = this.province;
    data['country'] = this.country;
    data['lastUpdate'] = this.lastUpdate;
    data['keyId'] = this.keyId;
    data['confirmed'] = this.confirmed;
    data['deaths'] = this.deaths;
    data['recovered'] = this.recovered;
    return data;
  }
}