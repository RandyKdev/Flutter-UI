import 'package:books_app/providers/book.dart';
import 'package:books_app/providers/chat/chat.dart';
import 'package:books_app/providers/user.dart';
import 'package:books_app/services/auth.dart';
import 'package:books_app/utils/location_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  final CollectionReference userDataCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');

  DatabaseService({this.uid});

  Stream<List<UserData>> get allUsers {
    return userDataCollection.snapshots().map(getAllUserData);
  }

  Stream<List<Book>> get booksData {
    return booksCollection
        .doc(uid)
        .collection('ownedBooks')
        .snapshots()
        .map(_bookFromQuerySnapShot);
  }

  //get user data from stream with uid
  Stream<UserData> get userData {
    return userDataCollection
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) => _userDataFromSnapShot(snapshot));
    // .map(_userDataFromSnapShot);
  }

  //Update Users Location
  Future addBook(Book book) async {
    //GET BOOK FROM API or an existing List
    return booksCollection
        .doc(uid)
        .collection('ownedBooks')
        .doc(book.isbn)
        .set(<String, dynamic>{
      'rating': book.rating,
      'isbn': book.isbn,
      'isBookMarked': book.isBookMarked,
      'isOwned': book.isOwned ?? false,
      'title': book.title,
      'description': book.description,
      'imageUrl': book.imageUrl,
      'author': book.author
    });
  }

  ///This is for chat TEST.
  //Get All users Data
  List<UserData> getAllUserData(QuerySnapshot querySnapshot) {
    // ignore: unrelated_type_equality_checks
    return querySnapshot.docs.where((QueryDocumentSnapshot uid) {
      return uid != uid;
    }).map((QueryDocumentSnapshot doc) {
      return UserData(
        // uid: uid,
        uid: doc.data()['uid'] as String,
        displayName: doc.data()['displayName'] as String ?? 'Enter Name',
        email: doc.data()['email'] as String ?? 'example@example.com',
        phoneNumber: doc.data()['phoneNumber'] as String ?? '8844883333',
        state: doc.data()['state'] as String,
        city: doc.data()['city'] as String,
        photoURL: doc.data()['photoURL'] as String,
        preferences: doc.data()['preferences'] as Map<String, dynamic>,
        latitude: doc.data()['latitude'] as double,
        longitude: doc.data()['longitude'] as double,
      );
    }).toList();
  }

  void removeBook(String isbn) {
    booksCollection
        .doc(uid)
        .collection('ownedBooks')
        .doc(isbn)
        .delete()
        .catchError((dynamic e) => print(e.toString()));
  }

  Future<void> updateBookMark(Book book) async {
    //Get
    print("Hello there");

    final DocumentReference docReference =
        booksCollection.doc(uid).collection('ownedBooks').doc(book.isbn);
    docReference.update(<String, dynamic>{
      'isBookMarked': book.isBookMarked,
    });
  }

  Future<void> updateGenres(List<String> genres) async {
    return userDataCollection.doc(uid).set(<String, dynamic>{
      'preferences': <String, dynamic>{'genres': genres}
    }, SetOptions(merge: true));
  }

  Future updatePreferences(
      String favAuthor, String favBook, String locationRange) async {
    return userDataCollection.doc(uid).set(<String, dynamic>{
      'preferences': {
        'favAuthor': favAuthor,
        'favBook': favBook,
        'locationRange': locationRange
      }
    }, SetOptions(merge: true));
  }

  //get Book data from stream with uid
  // Stream<List<Book>> get booksData {
  //   return booksCollection.snapshots().map((_bookFromQuerySnapShot));
  // }

  //Read from firestore
  void updateRating(double star, String isbn) {
    booksCollection
        .doc(uid)
        .collection('ownedBooks')
        .doc(isbn)
        .set(<String, dynamic>{
      'rating': star,
    }, SetOptions(merge: true)).then((_) => print('Done'));
  }

  //*********Updates***************//
  //1.0->Update Rating a book by giving Star
  Future updateUser(
      String name, String city, String state, String photoURL) async {
    return userDataCollection.doc(uid).set(<String, dynamic>{
      'city': city,
      'state': state,
      'displayName': name,
      'photoURL': photoURL,
    }, SetOptions(merge: true));
  }

  //2.0->Update BookMark toggle bookmark
  Future updateUserData(UserData userData) async {
    return userDataCollection.doc(uid).set(
      <String, dynamic>
      // ignore: always_specify_types
      {
        'uid': uid,
        // 'token':
        'displayName': userData.displayName,
        'email': userData.email,
        'emailVerified': userData.emailVerified,
        'isAnonymous': userData.isAnonymous,
        'phoneNumber': userData.phoneNumber,
        'photoURL': userData.photoURL,
        'city': userData.city,
        'state': userData.state,
        'country': userData.countryName,
        // ignore: always_specify_types
        'preferences': {
          'favAuthor': '',
          'favBook': '',
          'locationRange': '10',
        },
        'latitude': userData.latitude,
        'longitude': userData.longitude,
      },
    );
  }

  Future updateUserLocation(double latitude, double longitude) async {
    final List<String> addresses =
        await LocationHelper().getAddressFromLatLng(latitude, longitude);

    return userDataCollection.doc(uid).set(<String, dynamic>{
      'city': addresses[0],
      'state': addresses[1],
      'country': addresses[2],
      'latitude': latitude,
      'longitude': longitude,
    }, SetOptions(merge: true));
  }

  List<Book> _bookFromQuerySnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot doc) {
      // print(doc.data);
      return Book(
          rating: doc.data()['rating'] as double,
          isOwned: doc.data()['isOwned'] as bool,
          isBookMarked: doc.data()['isBookMarked'] as bool,
          imageUrl: doc.data()['imageUrl'] as String,
          title: doc.data()['title'] as String,
          isbn: doc.data()['isbn'] as String,
          author: doc.data()['author'] as String,
          description: doc.data()['description'] as String);
    }).toList();
  }

  UserData _userDataFromSnapShot(DocumentSnapshot documentSnapshot) {
    return UserData(
      uid: uid,
      displayName:
          documentSnapshot.data()['displayName'] as String ?? 'Enter Name',
      email:
          documentSnapshot.data()['email'] as String ?? 'example@example.com',
      phoneNumber:
          documentSnapshot.data()['phoneNumber'] as String ?? '8844883333',
      state: documentSnapshot.data()['state'] as String,
      city: documentSnapshot.data()['city'] as String,
      photoURL: documentSnapshot.data()['photoURL'] as String,
      preferences:
          documentSnapshot.data()['preferences'] as Map<String, dynamic>,
      latitude: documentSnapshot.data()['latitude'] as double,
      longitude: documentSnapshot.data()['longitude'] as double,
    );
  }

  Future<DocumentReference> createChat(String participatingUserId) {
    final FirebaseAuthService _auth = FirebaseAuthService();
    final String _uid = _auth.getUID;
    return chatCollection.add(<String, dynamic>{
      'users': [participatingUserId, _uid],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getAllChats() {
    final FirebaseAuthService _auth = FirebaseAuthService();
    final String _uid = _auth.getUID;
    return chatCollection
        .where('users', arrayContains: _uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllMessagesFromChat(String chatId) {
    return chatCollection
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

  // todo: Handle the delivered and seen cases

  Future<String> getChatParticipatingUserID(String chatId) async {
    final DocumentSnapshot _chat = await chatCollection.doc(chatId).get();
    final List<String> _users = _chat.data()['users'] as List<String>;
    final FirebaseAuthService _auth = FirebaseAuthService();
    final String _uid = _auth.getUID;
    return _users[1 - _users.indexOf(_uid)];
  }

  Future<DocumentReference> sendMessage(String chatId, String message) async {
    final FirebaseAuthService _auth = FirebaseAuthService();
    final String _sender = _auth.getUID;
    final String _receiver = await getChatParticipatingUserID(chatId);
    return chatCollection
        .doc(chatId)
        .collection('messages')
        .add(<String, dynamic>{
      'message': message,
      'sender': _sender,
      'receiver': _receiver,
      'createdAt': FieldValue.serverTimestamp(),
      'delivered': false,
      'seen': false,
    });
  }
  //**End of DB service
}
