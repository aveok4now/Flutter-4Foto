class RenditionEntity{
  final String? url;
  final String? width;
  final String? height;
  
  RenditionEntity({
    this.url,
    this.width,
    this.height,
  });

  factory RenditionEntity.fromJson(Map<String, dynamic> json){
    return RenditionEntity(
      url: json['url'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
    );
  } 
}