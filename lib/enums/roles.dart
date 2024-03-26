enum Role{
  admin("Admin", "admin"),
  wart("Gerätewart", "wart"),
  user("User","user");

  const Role(this.label, this.value);

  final String label;
  final String value;
}