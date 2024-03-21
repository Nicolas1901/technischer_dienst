enum Role{
  admin("admin", "admin"),
  wart("wart", "wart"),
  user("user","user");

  const Role(this.label, this.value);

  final String label;
  final String value;
}