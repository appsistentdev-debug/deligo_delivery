enum Flavor {
  deligo,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.deligo:
        return 'YourAppName';
    }
  }

  static String get apiBase {
    switch (appFlavor) {
      case Flavor.deligo:
        return "https://deligo.vtlabs.dev/";
    }
  }

  static String get logo {
    switch (appFlavor) {
      case Flavor.deligo:
        return "assets/flavors/logo/deligo/logo.png";
    }
  }

  static String get logoLight {
    switch (appFlavor) {
      case Flavor.deligo:
        return "assets/flavors/logo/deligo/logo_light.png";
    }
  }
}
