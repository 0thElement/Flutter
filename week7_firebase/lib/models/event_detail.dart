class EventDetail {
  String? id;
  String? description;
  String? date;
  String? startTime;
  String? endTime;
  String? speaker;
  bool isFavorite = false;

  EventDetail(
    this.id,
    this.description,
    this.date,
    this.startTime,
    this.endTime,
    this.speaker,
    this.isFavorite,
  );

  EventDetail.fromMap(dynamic obj) {
    id = obj.id;
    description = obj['description'];
    date = obj['date'];
    startTime = obj['start_time'];
    endTime = obj['end_time'];
    speaker = obj['speaker'];
    isFavorite = obj['is_favorite'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) {
      map['id'] = id;
    }
    map['description'] = description;
    map['date'] = date;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['speaker'] = speaker;
    map['isFavorite'] = isFavorite;
    return map;
  }
}
