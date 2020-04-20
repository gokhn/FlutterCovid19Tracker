class NewsDataResponse {
  List<NewsResult> newsResult;
  bool success;

  NewsDataResponse(this.success, [this.newsResult]);

  factory NewsDataResponse.fromJson(dynamic json)
   {
    if (json['result'] != null)
     {
      var tagObjsJson = json['result'] as List;
      List<NewsResult> _newsResult =
          tagObjsJson.map((tagJson) => NewsResult.fromJson(tagJson)).toList();

      return NewsDataResponse(json['success'] as bool, _newsResult);
    } 
    else 
    {
      List<NewsResult> _empty =  List<NewsResult>();
      return NewsDataResponse(json['success'] as bool,_empty);
    }
  }
}

class NewsResult {
  final String url;
  final String description;
  final String image;
  final String name;
  final String source;
  final String date;
  NewsResult(
      {this.url,
      this.description,
      this.image,
      this.name,
      this.source,
      this.date});

  factory NewsResult.fromJson(Map<String, dynamic> json) {
    return NewsResult(
        url: json['url'],
        description: json['description'] != null ? json['description'].toString().length > 50 ? json['description'].toString().substring(0,48) +" ..." :  json['description'].toString() : "",
        image: json['image'],
        name: json['name'],
        source: json['source'],
        date: json['date']);
  }
}
