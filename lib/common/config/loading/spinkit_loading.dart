import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/loading_config.dart';

class SpinkitLoading extends StatelessWidget {
  final LoadingConfig loadingConfig;
  const SpinkitLoading(this.loadingConfig);

  @override
  Widget build(BuildContext context) {
    var size = double.parse((loadingConfig.size ?? 30.0).toString());
    Widget icon;
    var color = Theme.of(context).primaryColor;
    switch (loadingConfig.type) {
      case 'rotatingPlain':
        icon =Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
            // SpinKitRotatingPlain(
          // color: color,
          // size: size,
        // );
        break;
      case 'doubleBounce':
        icon = Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
        //     SpinKitDoubleBounce(
        //   color: color,
        //   size: size,
        // );
        break;
      case 'wave':
        icon = Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
        //     SpinKitWave(
        //   color: color,
        //   size: size,
        // );
        break;
      case 'wanderingCubes':
        icon = Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
        //     SpinKitWanderingCubes(
        //   color: color,
        //   size: size,
        // );
        break;
      case 'fadingFour':
        icon = Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
        //     SpinKitFadingFour(
        //   color: color,
        //   size: size,
        // );
        break;
      case 'pulse':
        icon = Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);

        //     SpinKitPulse(
        //   color: color,
        //   size: size,
        // );
        break;
      case 'chasingDots':
        icon = Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
        //     SpinKitChasingDots(
        //   color: color,
        //   size: size,
        // );
        break;
      case 'threeBounce':
        icon =Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
        //     SpinKitThreeBounce(
        //   color: color,
        //   size: size,
        // );
        break;
      case 'circle':
        icon = Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
            // SpinKitCircle(
          // color: color,
          // size: size,
        // );
        break;
      case 'cubeGrid':
        icon =Image.asset('assets/icons_for_loading.gif',width: 200,
            height: 200);
            // SpinKitCubeGrid(
          // color: color,
          // size: size,
        // );
        break;
      case 'fadingCircle':
        icon  = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitFadingCircle(
          // color: color,
          // size: size,
        // );
        break;
      case 'rotatingCircle':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitRotatingCircle(
          // color: color,
          // size: size,
        // );
        break;
      case 'foldingCube':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitFoldingCube(
          // color: color,
          // size: size,
        // );
        break;
      case 'pumpingHeart':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitPumpingHeart(
          // color: color,
          // size: size,
        // );
        break;
      case 'dualRing':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitDualRing(
          // color: color,
          // size: size,
        // );
        break;
      case 'hourGlass':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitHourGlass(
          // color: color,
          // size: size,
        // );
        break;
      case 'fadingGrid':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);

            // SpinKitFadingGrid(
          // color: color,
          // size: size,
        // );
        break;
      case 'ring':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitRing(
          // color: color,
          // size: size,
        // );
        break;
      case 'ripple':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitRipple(
          // color: color,
          // size: size,
        // );
        break;
      case 'spinningCircle':
        icon =Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);
            // SpinKitSpinningCircle(
          // color: color,
          // size: size,
        // );
        break;
      case 'squareCircle':
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
            height: 200);

            // SpinKitSquareCircle(
          // color: color,
          // size: size,
        // );
        break;
      default:
        icon = Image.asset("assets/icons_for_loading.gif",width: 200,
          height: 200);
        //     SpinKitFadingCube(
        //   color: color,
        //   size: size,
        // );
    }

    ///psm loader
    return Center(
      child:    Image.asset("assets/icons_for_loading.gif",width: 200,
          height: 200,fit: BoxFit.cover,),
    );
  }
}
