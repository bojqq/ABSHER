class UserProfile {
  final String name;
  final String idNumber;
  final String? profileImage;

  UserProfile({
    required this.name,
    required this.idNumber,
    this.profileImage,
  });

  static UserProfile get mock => UserProfile(
        name: 'إلياس محمد ناصر البدوي الغامدي',
        idNumber: '١١٢٩٣٤٥١٩٣',
        profileImage: 'Me.png',
      );
}
