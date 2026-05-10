class ContactLink {
  const ContactLink({
    required this.label,
    required this.value,
    required this.icon,
    this.url,
    this.note,
  });

  final String label;
  final String value;
  final String icon;
  final String? url;
  final String? note;

  bool get isAvailable => url != null && url!.isNotEmpty;
}
