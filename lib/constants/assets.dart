enum Assets { background }

extension AssetsExtension on Assets {
  String get path {
    switch (this) {
      case Assets.background:
        return "assets/background.jpg";
      default:
        return "";
    }
  }
}
