class ErrorCategory{
  String name;
  String id;
  String description;

  ErrorCategory({
    this.name,
    this.id,
    this.description
});

  Map<String, dynamic> toJson() {
    var myMap = {
      "beschreibung": this.description,
      "id": " "
    };
    return {
      this.name: myMap
    };
  }

  factory ErrorCategory.fromJson(Map<String, dynamic> item) {
    var entryList = item.entries.toList();
    return ErrorCategory(
        name: entryList[0].key,
        id: entryList[0].value['id'].toString(),
        description: entryList[0].value['beschreibung']
    );
  }
}