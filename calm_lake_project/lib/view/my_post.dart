import 'package:calm_lake_project/view/edit_post.dart';
import 'package:calm_lake_project/view/insert.dart';
import 'package:calm_lake_project/vm/vm_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class MyPost extends StatelessWidget {
  final GetStorage box = GetStorage();
  MyPost({super.key});

  @override
  Widget build(BuildContext context) {
    final vmHandler = Get.put(VmHandler());
    String userId = box.read('userId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posting'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => Insert())!
            .then((value) => vmHandler.getUserPostJSONData(userId)),
      ),
      body: GetBuilder<VmHandler>(
        builder: (controller) {
          return FutureBuilder(
            future: controller.getUserPostJSONData(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              } else {
                return Obx(
                  () {
                    return ListView.builder(
                      itemCount: vmHandler.userposts.length,
                      itemBuilder: (context, index) {
                        final userpost = vmHandler.userposts[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(),
                                Text(userpost[1]),
                                Spacer(),
                                PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      Get.to(EditPost(), arguments: userpost);
                                    } else {
                                      Get.defaultDialog(
                                          title: 'Delete',
                                          titleStyle: TextStyle(fontSize: 20),
                                          content: Text(
                                              'Do you want to delete the comment?'),
                                          onConfirm: () async {
                                            var result = await vmHandler
                                                .deleteCommentJSONData(userId);
                                            if (result == 'OK') {
                                              Get.back();
                                              await vmHandler
                                                  .getComment(userpost[0]);
                                            } else {
                                              Get.snackbar('Error', 'error');
                                            }
                                          },
                                          buttonColor: Colors.grey,
                                          contentPadding: EdgeInsets.all(10));
                                    }
                                  },
                                  itemBuilder: (BuildContext bc) {
                                    return const [
                                      PopupMenuItem(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Edit"),
                                            Icon(Icons.edit)
                                          ],
                                        ),
                                        value: 'Edit',
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Delete"),
                                            Icon(Icons.delete)
                                          ],
                                        ),
                                        value: 'Delete',
                                      ),
                                    ];
                                  },
                                )
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: Container(
                                child: Image.network(
                                  'http://127.0.0.1:8000/query/view/${userpost[3]}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                // 좋아요 아이콘
                                GestureDetector(
                                  onTap: () async {
                                    /*
                                    bool check = await vmHandler.checkFavorite(
                                            post[7] ?? 'null', post[8] ?? 0) ==
                                        post[6];
                                    print(await vmHandler.checkFavorite(
                                        post[7] ?? 'null', post[8] ?? 0));
                                    int newFavoriteValue =
                                        post[9] == '1' ? 0 : 1;
                                    // favorite 테이블이 있고 hate 테이블이 있는경우
                                    // favorite 1이고 hate가 0이면 updateFavorite
                                    // favorite 1이고 hate가 1이면 updatehate, updatefavorite
                                    // favorite 0이고 hate가 0이면 updateFavorite
                                    // favorite 0이고 hate가 1이면 updateFavorite
                                    // favorite 테이블이 있고 hate 테이블이 없는경우 updateFavorite
                                    if (check) {
                                      if (newFavoriteValue == 1 &&
                                          post[13] == '1') {
                                        await vmHandler.updateHate(
                                            0, post[12], post[11]);
                                        await vmHandler.updateFavorite(
                                            newFavoriteValue, post[8], post[7]);
                                      }
                                      await vmHandler.updateFavorite(
                                          newFavoriteValue, post[8], post[7]);
                                      // favorite 테이블이 없고 hate 테이블이 없는경우 inserFavorite 1
                                      // favorite 테이블이 없고 hate 테이블이 있는경우
                                      // hate가 1이면 insertfavorite 1, updatehate
                                      // hate가 0이면 insertfavofite 1
                                    } else {
                                      if (post[13] == '1') {
                                        await vmHandler.updateHate(
                                            0, post[12], post[11]);
                                        await vmHandler.insertFavorite(
                                            1, post[0], 'user');
                                      } else {
                                        await vmHandler.insertFavorite(
                                            1, post[0], 'user');
                                      }
                                    }
                                    await vmHandler.getJSONData(); */
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child:
                                        /*post[9] == '1'
                                        ? Icon(Icons.favorite)
                                        : */
                                        Icon(Icons.favorite_border),
                                  ),
                                ),
                                // 싫어요 아이콘
                                GestureDetector(
                                  onTap: () async {
                                    /*
                                    bool check = await vmHandler.checkHate(
                                            post[11] ?? 'null',
                                            post[12] ?? 0) ==
                                        post[10];
                                    int newHateValue = post[13] == '1' ? 0 : 1;
                                    if (check) {
                                      if (newHateValue == 1 && post[9] == '1') {
                                        await vmHandler.updateFavorite(
                                            0, post[8], post[7]);
                                        await vmHandler.updateHate(
                                            newHateValue, post[12], post[11]);
                                      }
                                      await vmHandler.updateHate(
                                          newHateValue, post[12], post[11]);
                                    } else {
                                      if (post[9] == '1') {
                                        await vmHandler.updateFavorite(
                                            0, post[8], post[7]);
                                        await vmHandler.insertHate(
                                            1, post[0], 'user');
                                      } else {
                                        await vmHandler.insertHate(
                                            1, post[0], 'user');
                                      }
                                    }
                                    await vmHandler.getJSONData();*/
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: /*
                                        post[13] == '1'
                                        ? Icon(Icons.thumb_down)
                                        : */
                                        Icon(Icons.thumb_down_alt_outlined),
                                  ),
                                ),
                                // 코멘트 아이콘
                                GestureDetector(
                                  onTap: () {
                                    controller.getComment(userpost[0]);
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled:
                                          true, // 키보드가 나타날 때 modal 크기를 조정
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.9 -
                                                MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom *
                                                    1,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15, bottom: 10),
                                                  child: Text(
                                                    'Commnets',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Divider(),
                                                Expanded(
                                                  child: Obx(() {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      //physics: NeverScrollableScrollPhysics(), // 스크롤 방지
                                                      itemCount: controller
                                                          .comments.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            ListTile(
                                                              leading:
                                                                  CircleAvatar(),
                                                              title: Text(
                                                                  controller
                                                                      .comments[
                                                                          index]
                                                                          [1]
                                                                      .toString()),
                                                              subtitle: Text(
                                                                  controller
                                                                      .comments[
                                                                          index]
                                                                          [3]
                                                                      .toString()),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 20),
                                                        child: TextField(
                                                          controller: controller
                                                              .textController,
                                                          maxLines: 1,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Enter comment',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 20),
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          if (controller
                                                              .textController
                                                              .text
                                                              .trim()
                                                              .isNotEmpty) {
                                                            await controller
                                                                .insertCommnet(
                                                                    userpost[0],
                                                                    controller
                                                                        .textController
                                                                        .text
                                                                        .trim(),
                                                                    userId);
                                                            await controller
                                                                .getComment(
                                                                    userpost[
                                                                        0]);
                                                            controller
                                                                .textController
                                                                .text = '';
                                                          }
                                                        },
                                                        child: Icon(
                                                            Icons.arrow_upward),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 40,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Icon(Icons.chat_bubble_outline),
                                  ),
                                ), /*
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 10),
                                  child:
                                      Text(post[15] == 0 ? "" : "${post[15]}"),
                                )*/
                              ],
                            ),
                            // posting 내용
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${userpost[6]}\t${userpost[4]}'),
                                  Text(
                                      '${DateFormat("MMMM d").format(DateTime.parse(userpost[2]))}',
                                      style: TextStyle(color: Colors.black54)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
