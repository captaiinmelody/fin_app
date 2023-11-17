// import 'dart:convert';

// import 'package:collection/collection.dart';

// @immutable
// class PayloadData {
//   final String? reportsId;
//   final String? routerName;

//   const PayloadData({this.reportsId, this.routerName});

//   factory PayloadData.fromMap(Map<String, dynamic> data) => PayloadData(
//         reportsId: data['reportsId'] as String?,
//         routerName: data['routerName'] as String?,
//       );

//   Map<String, dynamic> toMap() => {
//         'reportsId': reportsId,
//         'routerName': routerName,
//       };

//   /// `dart:convert`
//   ///
//   /// Parses the string and returns the resulting Json object as [PayloadData].
//   factory PayloadData.fromJson(String data) {
//     return PayloadData.fromMap(json.decode(data) as Map<String, dynamic>);
//   }

//   /// `dart:convert`
//   ///
//   /// Converts [PayloadData] to a JSON string.
//   String toJson() => json.encode(toMap());

//   PayloadData copyWith({
//     String? reportsId,
//     String? routerName,
//   }) {
//     return PayloadData(
//       reportsId: reportsId ?? this.reportsId,
//       routerName: routerName ?? this.routerName,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(other, this)) return true;
//     if (other is! PayloadData) return false;
//     final mapEquals = const DeepCollectionEquality().equals;
//     return mapEquals(other.toMap(), toMap());
//   }

//   @override
//   int get hashCode => reportsId.hashCode ^ routerName.hashCode;
// }
