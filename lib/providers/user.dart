class UserData {
  String uid;
  String displayName;
  String email;
  bool emailVerified;
  String refreshToken;
  bool isAnonymous;
  String phoneNumber;
  String photoURL;
  String city;
  String state;
  double latitude;
  double longitude;
  double locationRange;
  String countryName;
  Map<String, dynamic> preferences;
  UserData(
      {this.uid,
      this.countryName,
      this.displayName,
      this.email,
      this.emailVerified,
      this.isAnonymous,
      this.phoneNumber,
      this.photoURL,
      this.city,
      this.state,
      this.refreshToken,
      this.latitude = 0.0,
      this.longitude = 0.0,
      this.preferences,
      this.locationRange});
}
