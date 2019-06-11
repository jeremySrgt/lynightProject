


class ClubData{

  ClubData({
    this.adress,
    this.availablePlaces,
    this.description,
    this.entryNumber,
    this.like,
    this.musics,
    this.name,
    this.phone,
    this.pictures,
    this.position,
    this.price,
    this.searchKey,
    this.siteUrl,
    this.storagePath,
    this.arrond,
});


  final String adress;
  final int availablePlaces;
  final String description;
  final int entryNumber;
  final int like;
  final Map<dynamic,dynamic> musics;
  final String name;
  final String phone;
  final List<String> pictures;
  final position; // c'est la position latitude et longitude => geopoint dans firestore mais jsp en dart le type
  final List<int> price;
  final String searchKey;
  final String siteUrl;
  final storagePath;
  final int arrond;


  Map<String,dynamic> getClubDataMap(){
    return {
      "adress":adress,
      "availablePlaces":availablePlaces,
      "description":description,
      "entryNumber":entryNumber,
      "like":like,
      "musics":musics,
      "name":name,
      "phone":phone,
      "pictures":pictures,
      "position":position,
      "price":price,
      "searchKey":searchKey,
      "siteUrl":siteUrl,
      "storagePath":storagePath,
      "arrond":arrond,
    };
  }

}