class ThemeSetting {
  bool status = false;

  ThemeSetting(this.status);
  ThemeSetting._myConstructor();
  static ThemeSetting instance = ThemeSetting._myConstructor();

  void setStatus(data) {
    status = data;
  }
}
