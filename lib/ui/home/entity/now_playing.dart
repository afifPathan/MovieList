import 'dart:convert';

import 'package:webclues_practical/ui/home/entity/movie.dart';

NowPlaying nowPlayingFromJson(Map<String, dynamic> map) => NowPlaying.fromJson(map);

String NowPlayingToJson(NowPlaying data) => json.encode(data.toJson());

class NowPlaying {
    List<Movie> movies;
    int page;
    int totalResults;
  //  Dates dates;
    int totalPages;

    NowPlaying({
        this.movies,
        this.page,
        this.totalResults,
      //  this.dates,
        this.totalPages,
    });

    factory NowPlaying.fromJson(Map<String, dynamic> json) => NowPlaying(
        movies: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        page: json["page"],
        totalResults: json["total_results"],
     //   dates: Dates.fromJson(json["dates"]),
        totalPages: json["total_pages"],
    );

    Map<String, dynamic> toJson() => {
        "movies": List<dynamic>.from(movies.map((x) => x.toJson())),
        "page": page,
        "total_results": totalResults,
      //  "dates": dates.toJson(),
        "total_pages": totalPages,
    };
}

class Dates {
    DateTime maximum;
    DateTime minimum;

    Dates({
        this.maximum,
        this.minimum,
    });

    factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );

    Map<String, dynamic> toJson() => {
        "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
    };
}


