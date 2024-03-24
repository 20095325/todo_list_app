bool getBool(dynamic value){
  switch(value) {
    case bool _:
      return value;
    case int _:
      return value == 0 ? false : true;
    default:
    return false;
  }
}