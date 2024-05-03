import 'package:beyond_vision/model/record_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordService {
  static const String baseUrl = "http://34.64.89.205/api/v1/exercise";

  Future<List<Record>> getAllRecord(int memberId) async {
    List<Record> recordInstance = [];

    final url = Uri.parse('$baseUrl/record/$memberId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> records = jsonDecode(utf8.decode(response.bodyBytes));

      for (var record in records) {
        DateTime dateTime = DateTime.parse(record['exerciseDate']);

        recordInstance.add(Record(
            record["recordId"],
            record["exerciseCount"],
            record["exerciseTime"],
            record["exerciseName"],
            dateTime,
            record["successCount"],
            record["caloriesBurnedSum"],
            record["averageHeartRate"]));
      }
      return recordInstance;
    }
    return recordInstance;
  }

  // Future<bool> addRecord(Record newRecord, int exerciseId, int memberId) async {
  //   exerciseId = 3;
  //   final url = Uri.https(baseUrl, '/record/:$exerciseId');
  //   var response = await http.post(url,
  //       headers: {"Content-Type": "application/json; charset=UTF-8"},
  //       body: json
  //           .encode({'exerciseTime': 20, 'exerciseCount': 0, 'memberId': 3}));

  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     recordList.add(data);
  //     return true;
  //   }
  //   throw Error();
  // }
}
