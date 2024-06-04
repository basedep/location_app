class FriendsList {
  final String? userId;
  final List<dynamic> arrayOfFriendsId;

  FriendsList({required this.userId, required this.arrayOfFriendsId});

  factory FriendsList.fromMap(Map<String, dynamic> map) {
    return FriendsList(
      userId: map['user_id'],
      arrayOfFriendsId: map['arrayOfFriendsId']
    );
  }
}