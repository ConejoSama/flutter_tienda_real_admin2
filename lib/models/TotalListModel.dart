class TotalModelList{
  int categoryTotal;
  int productTotal;
  int usersTotal;
  int ordersTotal;

  TotalModelList({this.categoryTotal,this.ordersTotal,this.productTotal,this.usersTotal});

  TotalModelList.fromMap(Map<String,dynamic> data,String id):
      categoryTotal=data['CategoryTotal'],
      productTotal=data['ProductTotal'],
      usersTotal=data['UsersTotal'],
      ordersTotal=data['OrdersTotal'];

  Map<String, dynamic> toMap(){
    return{
      'CategoryTotal':categoryTotal,
      'ProductTotal':productTotal,
      'UsersTotal':usersTotal,
      'OrdersTotal':ordersTotal,
    };
  }
}