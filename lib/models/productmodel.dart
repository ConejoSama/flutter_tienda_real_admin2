class ProductModel {
  final String pbrand;
  final String pcategory;
  final String id;
  final String pname;
  final String ppicture;
  final int pprice;
  final int pquantity;
  final String date;
  final String address;
  final String email;
  final String paymentid;

//  final String psale;
//  final String pfeatured;
//  List<String> pcolors;
//  List<String> psizes;

  ProductModel({this.pname,this.id,this.ppicture,this.pbrand,this.pcategory,this.pprice,this.pquantity,this.address,this.date,this.email,this.paymentid});
//  ,this.psizes,this.pcolors,this.psale,this.pfeatured
  ProductModel.fromMap(Map<String,dynamic> data, String id):
        pbrand=data["brand"],
        pcategory=data["category"],
        pname=data["name"],
        ppicture=data["picture"],
        pprice=data["price"],
        pquantity=data["quantity"],
        address=data['address'],
        date=data['date'],
        email=data['Email'],
        paymentid=data['paymentid'],
//        psale=data['sale'],
//        pfeatured=data["featured"],
//        pcolors=data['colors'],
//        psizes=data['sizes'],
        id=id;

  Map<String, dynamic> toMap() {
    return {
      "name": pname,
      "category": pcategory,
      'id':id,
      "brand": pbrand,
      "picture": ppicture,
      "price": pprice,
      "quantity": pquantity,
      "date":date,
      "address":address,
      "Email":email,
      "paymentid":paymentid,
//      "featured": pfeatured,
//      "sale": psale,
//      "colors" : pcolors,
//      "sizes": psizes,
    };
  }

}

class TotalModel {
  final int total;


  TotalModel(this.total);

  TotalModel.fromMap(Map<String,dynamic> data, String id):
        total=data["totalprice"];

  Map<String, dynamic> toMap() {
    return {
      'totalprice':total
    };
  }
}