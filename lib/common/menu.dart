import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/selected.dart';

class Menu extends StatelessWidget {
  final String keyValue;
  final IconData icon;
  final String text;

  const Menu({
    required this.keyValue,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    String selectedMenu = Provider.of<SelectedProvider>(context).getMenu();

    return GestureDetector(
      onTap: () {
        Provider.of<SelectedProvider>(context, listen: false)
            .selectedMenu(keyValue);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: selectedMenu == keyValue
              ? Theme.of(context).dialogBackgroundColor
              : Theme.of(context).canvasColor,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selectedMenu == keyValue
                  ? Theme.of(context).textTheme.bodyText1!.color
                  : Theme.of(context).textTheme.headline1!.color,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: selectedMenu == keyValue
                    ? Theme.of(context).textTheme.bodyText1!.color
                    : Theme.of(context).textTheme.headline1!.color,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
