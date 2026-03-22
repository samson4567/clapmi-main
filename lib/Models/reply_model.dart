class ReplyModel {
  final int? wierdID;

  final String? humanReadableDate;
  final String? content;

  final String? author;

  final String? authorUsername;

  ReplyModel({
    required this.authorUsername,
    required this.wierdID,
    required this.humanReadableDate,
    required this.content,
    required this.author,
  });

  ReplyModel copyWith({
    int? wierdID,
    String? humanReadableDate,
    String? content,
    String? author,
    String? authorUsername,
  }) {
    return ReplyModel(
      authorUsername: authorUsername ?? this.authorUsername,
      wierdID: wierdID ?? this.wierdID,
      humanReadableDate: humanReadableDate ?? this.humanReadableDate,
      content: content ?? this.content,
      author: author ?? this.author,
    );
  }

  factory ReplyModel.fromSqlitejson(Map json) {
    return ReplyModel(
      authorUsername: json['author_username'],
      wierdID: json['id'],
      humanReadableDate: json['human_readable_date'],
      content: json['content'],
      author: json['author'],
    );
  }

  factory ReplyModel.fromOnlinejson(Map json) {
    return ReplyModel(
      authorUsername: json['author_username'],
      wierdID: json['id'],
      humanReadableDate: json['human_readable_date'],
      content: json['content'],
      author: json['author'],
    );
  }

  factory ReplyModel.dummy() {
    return ReplyModel(
      authorUsername: "author_username",
      wierdID: 0,
      humanReadableDate: "humanReadableDate",
      content: "content",
      author: "author",
    );
  }

  Map toMap() {
    return {
      'author_username': authorUsername,
      'wierdID': wierdID,
      'human_readable_date': humanReadableDate,
      'content': content,
      'author': author,
    };
  }

  @override
  String toString() {
    return "${super.toString()}>>> ${toMap()}";
  }
}
