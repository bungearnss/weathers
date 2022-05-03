class TemperatureUnitHelper {
  bool isFahrenheit = false;

  TemperatureUnitHelper(this.isFahrenheit);
  TemperatureUnitHelper._myConstructor();
  static TemperatureUnitHelper instance =
      TemperatureUnitHelper._myConstructor();

  void setStatus(data) {
    isFahrenheit = data;
  }
}
