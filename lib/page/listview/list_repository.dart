class ListRepository{

  List getData() {
    return List.generate(15, (index) => index);
  }

  Future<List> loadmore() async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(15, (index) => index);
  }

}