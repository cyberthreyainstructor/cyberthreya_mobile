class Machine {
  final String groupName;
  final String machineName;
  final String? snapshotName;

  Machine({required this.groupName, required this.machineName, this.snapshotName});

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      groupName: json['group_name'],
      machineName: json['machine_name'],
      snapshotName: json['snapshot_name'],
    );
  }
}
