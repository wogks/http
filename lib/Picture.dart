class Picture {
  final String previewURL;
  final String tags;

  Picture({ required this.previewURL, required this.tags});

  factory Picture.fromJson(Map<String, dynamic> json){
    return Picture(
      previewURL: json['previewURL'] as String,
      tags: json['tags'] as String
      );    
  }
}//질문 :이걸 왜 선언하는지