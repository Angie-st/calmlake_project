import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/music.dart';
import '../vm/vm_handler.dart';

class Musiclist extends StatelessWidget {
  Musiclist({super.key});
  final vmHandler = Get.put((VmHandler()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('music').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data!.docs;
            print(documents.toList());
            return ListView(
              children: documents.map((e) => buildItemWidgets(e)).toList(),
            );
          },
        ));
  }

  Widget buildItemWidgets(DocumentSnapshot doc) {
    final music = Music(
        image: doc['image'],
        mp3: doc['mp3'],
        name: doc['name'],
        singer: doc['singer']);
    return GestureDetector(
      onTap: () {
        // vmHandler.firebaseMusicFunction(music.mp3, music.image, music.name);
        print(doc);
        // Get.back();
      },
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(music.image),
                radius: 30,
              ),
              Column(
                children: [
                  Text(
                    '    ${music.name}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        music.singer,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
