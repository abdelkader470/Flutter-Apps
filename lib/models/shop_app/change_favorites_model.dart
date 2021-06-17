class ChangeFavoritesModel {
  String messages;
  bool status;
  ChangeFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messages = json['messages'];
  }
}
