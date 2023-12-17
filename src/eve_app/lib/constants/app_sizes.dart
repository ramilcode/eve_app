class AppSizes {
  static const int screenBreakPointPhone = 612;
  static const int screenBreakPointTablet = 900;
  static const int screenBreakPointBigTablet = 1200;
  static const int screenBreakPointLaptop = 1400;
  static const double mainContentPaddingPercentage = 0.2;
  static const double dialogPadding = 20.0;
  static const double contentTopPadding = 30;
  static const double searchRowHeight = 48;
  static const double maxBaseScreenWidth = 1600;

  static double calcScreenHorizontalPadding(double sWidth) {
    late double horizontalPadding;

    if (sWidth < screenBreakPointPhone) {
      //612
      horizontalPadding = 10;
    } else if (sWidth < screenBreakPointTablet) {
      //1024
      horizontalPadding = 40;
    } else if (sWidth < screenBreakPointLaptop) {
      //1600
      horizontalPadding = 80;
    } else {
      //AppDeviceType.desktop and bigger
      horizontalPadding = sWidth * AppSizes.mainContentPaddingPercentage + (sWidth - AppSizes.maxBaseScreenWidth) / 2;
    }
    // horizontalPadding = sWidth * AppSizes.mainContentPaddingPercentage;
    return horizontalPadding;
  }
}
