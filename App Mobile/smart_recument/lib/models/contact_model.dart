// models/contact_model.dart

class Contact {
  String name;
  String email;
  String phone;
  String subject;
  String desc;

  Contact({
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.desc,
  });

  @override
  String toString() {
    return '$name - $email';
  }
}
