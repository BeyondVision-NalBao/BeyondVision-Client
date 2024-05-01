class Record {
  final int? recordId;
  final int? exerciseCount;
  final int? exerciseTime;
  final String? exerciseName;
  final DateTime? exerciseDate;
  final int? successCount;
  final double? caloriesBurnedSum;
  final int? averageHeartRate;

  Record(
      this.recordId,
      this.exerciseCount,
      this.exerciseTime,
      this.exerciseName,
      this.exerciseDate,
      this.successCount,
      this.caloriesBurnedSum,
      this.averageHeartRate);

  Record.fromJson(Map<String, dynamic> json)
      : recordId = json['recordId'],
        exerciseCount = json['exerciseCount'],
        exerciseTime = json['exerciseTime'],
        exerciseName = json['exerciseName'],
        exerciseDate = json['exerciseDate'],
        successCount = json['successCount'],
        caloriesBurnedSum = json['caloriesBurnedSum'],
        averageHeartRate = json['averageHeartRate'];

  Map<String, dynamic> toJson() => {
        'recordId': recordId,
        'exerciseCount': exerciseCount,
        'exerciseTime': exerciseTime,
        'exerciseName': exerciseName,
        'exerciseDate': exerciseDate,
        'successCount': successCount,
        'caloriesBurnedSum': caloriesBurnedSum,
        'averageHeartRate': averageHeartRate,
      };
}
