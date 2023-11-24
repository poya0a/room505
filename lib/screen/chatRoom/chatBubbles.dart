import 'package:flutter/material.dart';
import 'package:do_it/config/palette.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

class ChatBubbles extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;
  final bool currentUser;
  final String message;
  final String sendTime;
  final bool today;
  final String date;
  final String read;

  const ChatBubbles({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.currentUser,
    required this.message,
    required this.sendTime,
    required this.today,
    required this.date,
    required this.read,
  });

  @override
  State<ChatBubbles> createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.headline1!.color,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: !widget.today
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 3),
                  child: Text(
                    widget.date,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              : null,
        ),
        Row(
          mainAxisAlignment: widget.currentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (widget.currentUser)
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
                        margin: EdgeInsets.only(top: 20),
                        backGroundColor: Palette.mainColor,
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                          ),
                          child: Text(
                            widget.message,
                            style: TextStyle(color: Colors.white),
                            softWrap: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.sendTime,
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
                        image: AssetImage(widget.userImage),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            if (!widget.currentUser)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: Container(
                                width: 260,
                                height: 400,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: const SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: AssetImage(widget.userImage),
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
                          margin: EdgeInsets.only(top: 5),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  widget.message,
                                  style: TextStyle(color: Palette.text),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.sendTime,
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
                            style: TextStyle(
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
