import 'package:flutter/material.dart';
import 'package:room505/auth.dart';
import 'package:room505/chat.dart';
import 'package:intl/intl.dart';
import 'package:room505/config/palette.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';
import 'package:room505/auth/authClass.dart';
import 'package:room505/screen/chatRoom/chatClass.dart';

class ChatBubbles extends StatefulWidget {
  final String userUid;
  final String userName;
  final String message;
  final DateTime dateTime;
  final bool dateCheck;
  final bool timeCheck;
  final String read;

  const ChatBubbles({
    required this.userUid,
    required this.userName,
    required this.message,
    required this.dateTime,
    required this.dateCheck,
    required this.timeCheck,
    required this.read,
  });

  @override
  State<ChatBubbles> createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  Emps notCurrentUser = Emps(
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    false,
    [],
    "",
    "",
    "",
  );

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthProvider>(context).getUserInfo();
    bool currentUser = user.uid == widget.userUid;
    List<Dept> depts = Provider.of<ChatProvider>(context).getUserList();
    String sendDate = DateFormat('yyyy년 MM월 dd일').format(DateTime(
        widget.dateTime.year, widget.dateTime.month, widget.dateTime.day));

    String sendTime = DateFormat('hh:mm a').format(widget.dateTime);

    for (var dept in depts) {
      notCurrentUser =
          dept.emps.firstWhere((user) => user.uid == widget.userUid,
              orElse: () => Emps(
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    false,
                    [],
                    "",
                    "",
                    "",
                  ));
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.headline1!.color,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: widget.dateCheck
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 3),
                  child: Text(
                    sendDate,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              : null,
        ),
        Row(
          mainAxisAlignment:
              currentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (currentUser)
              Row(
                children: [
                  widget.read != "0"
                      ? Text(
                          widget.read,
                          style: const TextStyle(
                            color: Palette.yellowColor,
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ChatBubble(
                        clipper:
                            ChatBubbleClipper5(type: BubbleType.sendBubble),
                        alignment: Alignment.topRight,
                        margin: const EdgeInsets.only(top: 20),
                        backGroundColor: Palette.mainColor,
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                          ),
                          child: Text(
                            widget.message,
                            style: const TextStyle(color: Colors.white),
                            softWrap: true,
                          ),
                        ),
                      ),
                      if (widget.timeCheck)
                        const SizedBox(
                          height: 5,
                        ),
                      if (widget.timeCheck)
                        Text(
                          sendTime,
                          style: TextStyle(
                              fontSize: 12,
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(user.userProfile != ""
                            ? user.userProfile
                            : 'images/profile.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            if (!currentUser)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<SelectedProvider>(context, listen: false)
                            .selectedUserProfile(notCurrentUser);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: AssetImage(notCurrentUser.image != ""
                                ? notCurrentUser.image
                                : 'images/profile.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 15, 0, 0),
                          child: Text(
                            widget.userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.text),
                          ),
                        ),
                        ChatBubble(
                          clipper: ChatBubbleClipper5(
                              type: BubbleType.receiverBubble),
                          backGroundColor: Theme.of(context).shadowColor,
                          margin: const EdgeInsets.only(top: 5),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  widget.message,
                                  style: const TextStyle(color: Palette.text),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.timeCheck)
                          const SizedBox(
                            height: 5,
                          ),
                        if (widget.timeCheck)
                          Text(
                            sendTime,
                            style: const TextStyle(
                                fontSize: 12, color: Palette.text),
                          )
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    widget.read != "0"
                        ? Text(
                            widget.read,
                            style: const TextStyle(
                              color: Palette.yellowColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }
}
