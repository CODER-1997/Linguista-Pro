class StudentModel {
  final String name;
  final String surname;
  final String phone;
  final String group;
  final List payments;
  final List grades;
  final List exams;
  final List studyDays;
  final String uniqueId;
  final String startedDay;
  final bool isDeleted;
  final String groupId;
  final bool isFreeOfcharge;
  final int orderInGroup;



  StudentModel( {
    required this.name,
    required this.surname,
    required this.phone,
    required this.group,
    required this.payments,
    required this.studyDays,
    required this.uniqueId,
    required this.exams,
    required this.grades,
    required this.startedDay,
    required this.isDeleted,
    required this.groupId,
    required this.isFreeOfcharge,
    required this.orderInGroup,

  });

// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name.toLowerCase(),
      'surname': surname.toLowerCase(),
      'phone': phone,
      'group': group,
      'exams': exams,
      'grades': grades,
      'payments': payments,
      'studyDays': studyDays,
      'uniqueId': uniqueId,
      'startedDay': startedDay,
      'isDeleted': isDeleted,
      'groupId': groupId,
      'isFreeOfcharge': isFreeOfcharge,
      'orderInGroup': orderInGroup,

    };
  }
}
