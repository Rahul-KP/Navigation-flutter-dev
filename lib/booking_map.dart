class BookingDetails {
  late String patient_name;
  late String age;
  late String preferred_hosp;
  late String gender;
  late double lat;
  late double lon;
  late String hashvalue;

  BookingDetails(String patient_name, String age, String preferred_hosp, String gender, double lat, double lon, String hashval) {
    this.patient_name = patient_name;
    this.age = age;
    this.preferred_hosp = preferred_hosp;
    this.gender = gender;
    this.lat = lat;
    this.lon = lon;
    this.hashvalue = hashval;
  }
}