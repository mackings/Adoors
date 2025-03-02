class ForumTopic {
  final String id;
  final String title;
  final String featuredImage;
  final String article;
  final String date;
  final String userName;
  final int views;
  final int commentCount;

  ForumTopic({
    required this.id,
    required this.title,
    required this.featuredImage,
    required this.article,
    required this.date,
    required this.userName,
    required this.views,
    required this.commentCount,
  });

  factory ForumTopic.fromJson(Map<String, dynamic> json) {
    return ForumTopic(
      id: json['s'],
      title: json['title'],
      featuredImage: json['featured_image'],
      article: json['article'],
      date: json['date'],
      userName: json['user_name'],
      views: int.parse(json['views']),
      commentCount: int.parse(json['comment_count']),
    );
  }

  static List<ForumTopic> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ForumTopic.fromJson(json)).toList();
  }
}

class Comment {
  final String id;
  final String blogId;
  final String comment;
  final String commentedTime;
  final String? realName;

  Comment({
    required this.id,
    required this.blogId,
    required this.comment,
    required this.commentedTime,
    this.realName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['s'],
      blogId: json['blog_id'],
      comment: json['comments'],
      commentedTime: json['commented_time'],
      realName: json['real_name'],
    );
  }

  static List<Comment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Comment.fromJson(json)).toList();
  }
}
