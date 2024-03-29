import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/friend_status.dart';

class FriendsRepository {
  getFriendFilterTwoEquals(arg1, arg2, arg3, arg4) async {
    var fetchedFriends;
    await FirebaseFirestore.instance
        .collection('friendList')
        .where(arg1, isEqualTo: arg2)
        .where(arg3, isEqualTo: arg4)
        .get()
        .then((value) {
      fetchedFriends = value;
    });
    return fetchedFriends;
  }

  getFriendFilterThreeEquals(arg1, arg2, arg3, arg4, arg5, arg6) async {
    var fetchedFriends;
    await FirebaseFirestore.instance
        .collection('friendList')
        .where(arg1, isEqualTo: arg2)
        .where(arg3, isEqualTo: arg4)
        .where(arg5, isNotEqualTo: arg6)
        .get()
        .then((value) {
      fetchedFriends = value;
    });
    return fetchedFriends;
  }

  deleteFriend(id) {
    FirebaseFirestore.instance.collection('friendList').doc(id).delete();
  }

  updateFriend(id, arg1) {
    FirebaseFirestore.instance.collection('friendList').doc(id).update(arg1);
  }

  addFriend(FriendStatus friendStatus) {
    FirebaseFirestore.instance.collection('friendList').add({
      'user1': friendStatus.user1Id,
      'user2': friendStatus.user2Id,
      'user1Username': friendStatus.senderUsername,
      'user2Username': friendStatus.receiverUsername,
      'status': friendStatus.status
    });
  }
}
