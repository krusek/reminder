import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminder/widgets/platform/platform_widget.dart';

class PlatformListItem extends PlatformWidget {
  final Widget child;
  final Function onPressed;
  PlatformListItem({this.child, this.onPressed});

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return MaterialListItem(child: child, onPressed: onPressed,);
  }

  @override
  Widget buildiOSWidget(BuildContext context) {
    return CupertinoListItem(child: child, onPressed: onPressed,);
  }
}

class MaterialListItem extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  MaterialListItem({Key key, this.child, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: this.child,
      onPressed: this.onPressed,
    );
  }

}

class CupertinoListItem extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  CupertinoListItem({Key key, this.child, this.onPressed}) : super(key: key);
  @override
  State<CupertinoListItem> createState() {
    return new _CupertinoListItemState(onPressed: onPressed);
  }
}

class _CupertinoListItemState extends State<CupertinoListItem> {
  var selected = false;
  final Function onPressed;

  _CupertinoListItemState({this.onPressed});
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          this.selected = true;
        });
      },
      onTapCancel: () {
        setState(() {
          this.selected = false;          
        });
      },

      onTap: () {
        setState(() {
          this.selected = false;
        });
        this.onPressed();
      },
      child: Container(
        color: selected ? CupertinoColors.lightBackgroundGray : null,
        child: this.widget.child,
      ),
    );
  }
}