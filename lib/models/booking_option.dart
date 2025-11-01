class BookingOption {
  String image;
  String title;
  String? subtitle;
  String? subtitle2;
  Function()? onTap;

  BookingOption(
    this.image,
    this.title, {
    this.subtitle,
    this.subtitle2,
    this.onTap,
  });
}
