import 'package:cloud_firestore/cloud_firestore.dart';

class BiometricHistory {
  final String? id;
  final DateTime date;
  final double weight;
  final double height;
  final String activityLevel;
  final int tdee;
  final double bmi;
  final HealthData? healthData;

  BiometricHistory({
    this.id,
    required this.date,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.tdee,
    required this.bmi,
    this.healthData,
  });

  factory BiometricHistory.fromFirestore(Map<String, dynamic> data, String id) {
    return BiometricHistory(
      id: id,
      date: data['date'].toDate(),
      weight: data['weight'].toDouble(),
      height: data['height'].toDouble(),
      activityLevel: data['activityLevel'],
      tdee: data['tdee'],
      bmi: data['bmi'].toDouble(),
      healthData: data['healthData'] != null
          ? HealthData.fromJson(data['healthData'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'tdee': tdee,
      'bmi': bmi,
      'healthData': healthData?.toJson(),
    };
  }
}

class HealthData {
  final int steps;
  final double distance; // in meters
  final int calories;
  final int activeMinutes;
  final SleepData? sleep;
  final HeartRateData? heartRate;
  final BloodPressureData? bloodPressure;
  final BloodGlucoseData? bloodGlucose;
  final OxygenSaturationData? oxygenSaturation;

  HealthData({
    required this.steps,
    required this.distance,
    required this.calories,
    required this.activeMinutes,
    this.sleep,
    this.heartRate,
    this.bloodPressure,
    this.bloodGlucose,
    this.oxygenSaturation,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      steps: json['steps'] ?? 0,
      distance: (json['distance'] ?? 0).toDouble(),
      calories: json['calories'] ?? 0,
      activeMinutes: json['activeMinutes'] ?? 0,
      sleep: json['sleep'] != null ? SleepData.fromJson(json['sleep']) : null,
      heartRate: json['heartRate'] != null
          ? HeartRateData.fromJson(json['heartRate'])
          : null,
      bloodPressure: json['bloodPressure'] != null
          ? BloodPressureData.fromJson(json['bloodPressure'])
          : null,
      bloodGlucose: json['bloodGlucose'] != null
          ? BloodGlucoseData.fromJson(json['bloodGlucose'])
          : null,
      oxygenSaturation: json['oxygenSaturation'] != null
          ? OxygenSaturationData.fromJson(json['oxygenSaturation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'distance': distance,
      'calories': calories,
      'activeMinutes': activeMinutes,
      'sleep': sleep?.toJson(),
      'heartRate': heartRate?.toJson(),
      'bloodPressure': bloodPressure?.toJson(),
      'bloodGlucose': bloodGlucose?.toJson(),
      'oxygenSaturation': oxygenSaturation?.toJson(),
    };
  }
}

class SleepData {
  final int totalMinutes;
  final int deepSleepMinutes;
  final int lightSleepMinutes;
  final int remSleepMinutes;
  final int awakeMinutes;
  final DateTime startTime;
  final DateTime endTime;

  SleepData({
    required this.totalMinutes,
    required this.deepSleepMinutes,
    required this.lightSleepMinutes,
    required this.remSleepMinutes,
    required this.awakeMinutes,
    required this.startTime,
    required this.endTime,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      totalMinutes: json['totalMinutes'] ?? 0,
      deepSleepMinutes: json['deepSleepMinutes'] ?? 0,
      lightSleepMinutes: json['lightSleepMinutes'] ?? 0,
      remSleepMinutes: json['remSleepMinutes'] ?? 0,
      awakeMinutes: json['awakeMinutes'] ?? 0,
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMinutes': totalMinutes,
      'deepSleepMinutes': deepSleepMinutes,
      'lightSleepMinutes': lightSleepMinutes,
      'remSleepMinutes': remSleepMinutes,
      'awakeMinutes': awakeMinutes,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
    };
  }
}

class HeartRateData {
  final int averageBpm;
  final int minBpm;
  final int maxBpm;
  final List<HeartRateRecord> records;

  HeartRateData({
    required this.averageBpm,
    required this.minBpm,
    required this.maxBpm,
    required this.records,
  });

  factory HeartRateData.fromJson(Map<String, dynamic> json) {
    return HeartRateData(
      averageBpm: json['averageBpm'] ?? 0,
      minBpm: json['minBpm'] ?? 0,
      maxBpm: json['maxBpm'] ?? 0,
      records: (json['records'] as List?)
              ?.map((e) => HeartRateRecord.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageBpm': averageBpm,
      'minBpm': minBpm,
      'maxBpm': maxBpm,
      'records': records.map((e) => e.toJson()).toList(),
    };
  }
}

class HeartRateRecord {
  final int bpm;
  final DateTime timestamp;

  HeartRateRecord({
    required this.bpm,
    required this.timestamp,
  });

  factory HeartRateRecord.fromJson(Map<String, dynamic> json) {
    return HeartRateRecord(
      bpm: json['bpm'] ?? 0,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bpm': bpm,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class BloodPressureData {
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime timestamp;

  BloodPressureData({
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.timestamp,
  });

  factory BloodPressureData.fromJson(Map<String, dynamic> json) {
    return BloodPressureData(
      systolic: json['systolic'] ?? 0,
      diastolic: json['diastolic'] ?? 0,
      pulse: json['pulse'] ?? 0,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class BloodGlucoseData {
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? mealType;
  final String? measurementType;

  BloodGlucoseData({
    required this.value,
    required this.unit,
    required this.timestamp,
    this.mealType,
    this.measurementType,
  });

  factory BloodGlucoseData.fromJson(Map<String, dynamic> json) {
    return BloodGlucoseData(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'mg/dL',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      mealType: json['mealType'],
      measurementType: json['measurementType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'unit': unit,
      'timestamp': Timestamp.fromDate(timestamp),
      'mealType': mealType,
      'measurementType': measurementType,
    };
  }
}

class OxygenSaturationData {
  final double value;
  final DateTime timestamp;

  OxygenSaturationData({
    required this.value,
    required this.timestamp,
  });

  factory OxygenSaturationData.fromJson(Map<String, dynamic> json) {
    return OxygenSaturationData(
      value: (json['value'] ?? 0).toDouble(),
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
