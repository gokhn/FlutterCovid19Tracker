
class TotalDataResponse {
  final String totalDeaths;
  final String totalCases;
  final String totalRecovered;  
   bool success;
  TotalDataResponse({this.totalDeaths, this.totalCases, this.totalRecovered,this.success});

  factory TotalDataResponse.fromJson(Map<String, dynamic> json) {
    return TotalDataResponse(
      totalDeaths: json['totalDeaths'],
      totalCases: json['totalCases'],
      totalRecovered: json['totalRecovered'],  
      success:json['success'],   
    );
  }
}
