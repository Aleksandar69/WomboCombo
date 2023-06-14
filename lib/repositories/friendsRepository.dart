import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wombocombo/models/friend_status.dart';

class FriendsRepository {
  getFriendFilterIsEqualTo(
    arg1,
    arg2,
  ) async {
    var fetchedFriend;
    await FirebaseFirestore.instance
        .collection('friendList')
        .where(arg1, isEqualTo: arg2)
        .get()
        .then((value) {
      fetchedFriend = value;
    });
    return fetchedFriend;
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
      'status': friendStatus.status
    });
  }
}
