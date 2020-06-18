class SaferDay {
  DateTime saferOn;
  DateTime today;
  SaferDay(this.saferOn, this.today);

  int getSaferDay() {
    var _difference = today.difference(saferOn);
    return _difference.inDays + 1;
  }
}
