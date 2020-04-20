class CountriesDataResponse {
  List<CountryResult> countriesResult;
  bool success;

  CountriesDataResponse(this.success, [this.countriesResult]);

  factory CountriesDataResponse.fromJson(dynamic json)
   {
    if (json['result'] != null)
     {
      var tagObjsJson = json['result'] as List;
      List<CountryResult> _countriesResult =
          tagObjsJson.map((tagJson) => CountryResult.fromJson(tagJson)).toList();

      return CountriesDataResponse(json['success'] as bool, _countriesResult);
    } 
   else 
    {
      List<CountryResult> _empty =  List<CountryResult>();
      return CountriesDataResponse(json['success'] as bool,_empty);
    }
  }
}

class CountryResult {
  final String country;
  final String totalcases;
  final String newCases;
  final String totaldeaths;
  final String newDeaths;
  final String totalRecovered;
   final String activeCases;
  CountryResult(
      {this.country,
      this.totalcases,
      this.newCases,
      this.totaldeaths,
      this.newDeaths,
      this.totalRecovered,
      this.activeCases});

  factory CountryResult.fromJson(Map<String, dynamic> json) 
  {
    return CountryResult(
        country: json['country'] != null ? json['country'] :"",
        totalcases: json['totalCases'] != null ? json['totalCases'] :"" ,
        newCases: json['newCases'] != null ?  json['newCases'] :"",
        totaldeaths: json['totalDeaths'] != null ? json['totalDeaths'] : "",
        newDeaths: json['newDeaths'] != null ? json['newDeaths'] :"",
        totalRecovered: json['totalRecovered'] != null ? json['totalRecovered'] :"",
        activeCases: json['activeCases'] != null ? json['activeCases'] : ""
        );

  }
}
