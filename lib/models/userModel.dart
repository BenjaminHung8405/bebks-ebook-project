class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final PictureModel? pictures;

  UserModel({
    this.id  = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.pictures,
  });
}

class PictureModel {
  final String large;
  final String medium;
  final String thumbnail;

  PictureModel({
    this.large = '',
    this.medium = '',
    this.thumbnail = '',
  });
}