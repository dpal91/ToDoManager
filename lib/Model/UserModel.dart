class UserModel{
  String Name;
  String Email;
  String Contact;
  String password;

  UserModel(this.Name, this.Email, this.Contact, this.password);

  String toString()
  {
    return " Name= "+Name+" Email= "+Email+" Contact= "+Contact+" Password= "+password;
  }
}