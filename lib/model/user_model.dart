class User {
  final int? memberId;
  final String name;
  final String email;
  final String socialId;
  final String profileImageUrl;
  late int? age;
  late String? gender;
  late int exerciseGoal = 0;
  late int? weight;
  final bool? isNewMember;

  User(
      this.memberId,
      this.name,
      this.email,
      this.socialId,
      this.profileImageUrl,
      this.age,
      this.gender,
      this.exerciseGoal,
      this.isNewMember);

  User.fromJson(Map<String, dynamic> json)
      : memberId = json['memberId'],
        name = json['name'],
        email = json['email'],
        socialId = json['socialId'],
        profileImageUrl = json['profileImageUrl'],
        age = json['age'],
        gender = json['gender'],
        exerciseGoal = json['exerciseGoal'],
        weight = json['weight'],
        isNewMember = json['isNewMember'];

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'name': name,
        'email': email,
        'socialId': socialId,
        'profileImageUrl': profileImageUrl,
        'age': age,
        'gender': gender,
        'exerciseGoal': exerciseGoal,
        'weight': weight,
        'isNewMember': isNewMember,
      };
}
