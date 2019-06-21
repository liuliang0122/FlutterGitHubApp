import 'package:flutter/material.dart';
import 'package:flutter_rhine/common/constants/assets.dart';
import 'package:flutter_rhine/common/constants/colors.dart';
import 'package:flutter_rhine/common/providers/global_user_model.dart';
import 'package:provider/provider.dart';

class MainProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colorPrimary,
      child: Stack(
        alignment: Alignment.center,
        textDirection: TextDirection.ltr,
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 40.0, right: 16.0),
            child: Image(
              image: AssetImage(mineShared),
              width: 25.0,
              height: 25.0,
              fit: BoxFit.contain,
            ),
          ),
          _userInfoLayer(),
        ],
      ),
    );
  }

  Widget _userInfoLayer() {
    return Consumer<GlobalUserModel>(
      builder: (context, GlobalUserModel _userModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image(
                width: 70.0,
                height: 70.0,
                image: NetworkImage(_userModel.user.avatar_url),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: Text(
                _userModel.user.login ?? "unknown",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                _userModel.user.bio ?? "no description.",
                style: TextStyle(
                  fontSize: 14.0,
                  color: colorSecondaryTextGray,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 15.0,
                    height: 15.0,
                    image: AssetImage(mineLocationIcon),
                  ),
                  Text(
                    _userModel.user.location ?? 'no address.',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: colorSecondaryTextGray,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}