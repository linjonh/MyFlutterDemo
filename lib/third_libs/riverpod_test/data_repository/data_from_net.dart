import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'data_from_net.g.dart';

class MyRiverData {
  String? name;
  String? sex;
  String? address;

  MyRiverData(this.name, this.sex, this.address);
}

class DataRepository {
  List<MyRiverData> getDataList() {
    List<MyRiverData> datas = [];
    for (int i = 0; i < 10; i++) {
      datas.add(MyRiverData("name$i", "sex$i", "address$i"));
    }
    return datas;
  }
}

@RestApi(baseUrl: "https://localhost:8081/")
abstract class MyAPI {
  factory MyAPI(Dio dio, {String? baseUrl}) = _MyAPI;

  @GET("/")
  Future<String> goToHome();
}

void get() {
  var client = MyAPI(Dio());
  client.goToHome().then((item) => {});
}
