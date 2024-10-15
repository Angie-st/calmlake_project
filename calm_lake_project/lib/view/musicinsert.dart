import 'dart:io';

import 'package:calm_lake_project/vm/vm_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MusicInsert extends StatelessWidget {
  MusicInsert({super.key});
  final vmHandler = Get.put(VmHandler());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music insert'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: '타이틀을 입력하세요', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                    labelText: '부제목을 입력하세요', border: OutlineInputBorder()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            vmHandler.uploadFile();
                            vmHandler.changemp3State();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffD8EFCA),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2))),
                          child: const Text('Mp3 insert')),
                      Text(vmHandler.mp3UploadOk)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            vmHandler.galleryImage();
                            vmHandler.changeimageState();
                            vmHandler.reload();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF9D3CC),
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(2))),
                          child: const Text('Image insert')),
                      Text(vmHandler.imageUploadOk)
                    ],
                  ),
                ),
              ],
            ),
            //   Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: 200,
            //   color: Colors.grey,
            //   child: Center(
            //     child: vmHandler.showImage()
            //   ),
            // ),
            ElevatedButton(
                onPressed: () {
                  flieAllInsert();
                  vmHandler.changelastState();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD8EFCA),
                    shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(2))),
                child: const Text('File insert')),
          ],
        ),
      ),
    );
  }

  flieAllInsert() async {
    String image = await vmHandler.preparingImage();

    FirebaseFirestore.instance.collection('music').add({
      'name': titleController.text.trim(),
      'mp3': vmHandler.downloadMp3URL,
      'singer': subtitleController.text.trim(),
      'image': image
    });
  }
}
