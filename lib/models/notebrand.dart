class NoteBrand {
  final String title;
  final String description;
  final String id;

  NoteBrand({this.title, this.description, this.id});

  NoteBrand.fromMap(Map<String,dynamic> data, String id):
        title=data["brand"],
        description=data['description'],
        id=id;

  Map<String, dynamic> toMap() {
    return {
      "title" : title,
      "description":description,
    };
  }

}