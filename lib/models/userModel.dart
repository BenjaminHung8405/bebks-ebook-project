class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final PictureModel pictures;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.pictures
  });
}

class PictureModel {
  final String large;
  final String medium;
  final String thumbnail;

  PictureModel({
    required this.large,
    required this.medium,
    required this.thumbnail,
  });
}