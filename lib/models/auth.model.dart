class Auth {
  int status;
  bool success;
  String message;
  Object data;
  Auth({required this.status, required this.success, required this.message, required this.data});

  fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    data = json['data'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data_ = new Map<String, dynamic>();
    data_['status'] = this.status;
    data_['success'] = this.success;
    data_['message'] = this.message;
    data_['data'] = this.data;
    return data_;
  }
}