import 'package:flutter/material.dart';
import 'package:room505/config/palette.dart';
import 'package:provider/provider.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/temp/tempClass.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Widget build(BuildContext context) {
    User currentUser = Provider.of<CreatedProvider>(context).getUserInfo();
    User user = Provider.of<SelectedProvider>(context).getUserProfile();
    double width =
        Provider.of<MediaQueryProvider>(context).getUserProfileWidth();

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).dialogBackgroundColor,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).shadowColor,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 10,
                      child: Text(
                        "프로필",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        onPressed: () {
                          Provider.of<SelectedProvider>(context, listen: false)
                              .resetUserProfile();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 107,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage(user.image),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: user.status
                              ? Palette.greenColor
                              : Palette.textSub,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.status ? "대화 가능" : "자리 비움",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (user.updateStatus.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          IconData(
                            int.parse(user.updateStatus[0], radix: 16),
                            fontFamily: 'EmojiFontFamily',
                          ),
                          size: 16,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.updateStatus[1],
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (user.updateStatus.isNotEmpty)
                    const SizedBox(
                      height: 10,
                    ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "이메일",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "전화번호",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user.phone,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "소개",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  if (user.introduce.isNotEmpty)
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user.introduce,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (currentUser.seq == user.seq)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 40,
                            width: width / 2 - 26,
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "프로필 편집",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 40,
                            width: width / 2 - 26,
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "개인 정보 수정",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
