// ignore_for_file: non_constant_identifier_names

const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
    .document('messages/{groupId1}/{groupId2}/{message}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)

        const idFrom = doc.senderId
        const idTo = doc.receiverId
        const senderUsername = doc.senderUsername;
        const receiverUsername = doc.receiverUsername;
        const contentMessage = doc.text

        console.log('before admin.firestore');

        // Get push token user to (receive)
        return admin
            .firestore()
            .collection('users')
            .where('username', '==', receiverUsername)
            .get()
            .then(querySnapshot => {
                console.log('before query snapshot');
                querySnapshot.forEach(userTo => {
                    console.log('before foundUserTo');
                    console.log(`Found user to: ${userTo.data().username}`)
                    if (userTo.data().pushToken && userTo.data().chattingWith !== idFrom) {
                        // Get info user from (sent)
                        console.log('before second user');

                        admin
                            .firestore()
                            .collection('users')
                            .where('username', '==', senderUsername)
                            .get()
                            .then(querySnapshot2 => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().username}`)
                                    const message = {
                                        notification: {
                                            title: `You have a message from "${userFrom.data().username}"`,
                                            body: contentMessage,
                                        },
                                        token: userTo.data().pushToken,
                                    }
                                    // Let push to the target device
                                    console.log(`prije pusha`)

                                    admin
                                        .messaging()
                                        .send(message)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Can not find pushToken target user')
                    }
                })
            })
        return null
    })

exports.sendFriendNotification = functions.firestore
    .document('friendList/{friendrequest}')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)

        const idFrom = doc.user1;
        const idTo = doc.user2;
        const user1Username = doc.user1Username;
        const user2Username = doc.user2Username;

        console.log('before admin.firestore');

        // Get push token user to (receive)
        return admin
            .firestore()
            .collection('users')
            .where('username', '==', user2Username)
            .get()
            .then(querySnapshot => {
                console.log('before query snapshot');
                querySnapshot.forEach(userTo => {
                    console.log('before foundUserTo');
                    console.log(`Found user to: ${userTo.data().username}`)
                    if (userTo.data().pushToken) {
                        // Get info user from (sent)
                        console.log('before second user');

                        admin
                            .firestore()
                            .collection('users')
                            .where('username', '==', user1Username)
                            .get()
                            .then(querySnapshot2 => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().username}`)
                                    const message = {
                                        notification: {
                                            title: `You have a new friend request`,
                                            body: `From user "${userFrom.data().username}"`,
                                        },
                                        token: userTo.data().pushToken,
                                    }
                                    // Let push to the target device
                                    console.log(`prije pusha`)

                                    admin
                                        .messaging()
                                        .send(message)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Can not find pushToken target user')
                    }
                })
            })
        return null
    })