enum Flavor {
  delivery,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.delivery:
        return 'Deligo Delivery';
    }
  }

  static String get apiBase {
    switch (appFlavor) {
      case Flavor.delivery:
        return "http://10.0.2.2:8000/";
    }
  }

  static String get logo {
    switch (appFlavor) {
      case Flavor.delivery:
        return "assets/flavors/logo/delivery/logo.png";
    }
  }

  static String get logoLight {
    switch (appFlavor) {
      case Flavor.delivery:
        return "assets/flavors/logo/delivery/logo_light.png";
    }
  }
}
