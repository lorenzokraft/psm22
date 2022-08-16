import 'package:flutter/material.dart';

import '../index.dart';

class CategoryTextItem extends StatelessWidget {
  final String? name;
  final Function? onTap;
  final CommonItemConfig commonConfig;

  const CategoryTextItem({
    this.name,
    this.onTap,
    required this.commonConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: GestureDetector(
        onTap: () => onTap?.call(),
        child: Container(
              padding: EdgeInsets.symmetric(
              horizontal: commonConfig.paddingY,
              vertical: commonConfig.paddingX,
          ),
              height: 40,
              width: MediaQuery.of(context).size.width / 2.6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:name=='Food Items' ? Color(0xff11A551) : Color(0xffFF7A00),
              ),
              child: Text(name ?? '', style: Theme.of(context).textTheme.subtitle2?.apply(fontSizeFactor: commonConfig.size ?? 1,color: Colors.white)
                .copyWith(fontSize: commonConfig.labelFontSize),
                 maxLines: 2,
                 textAlign: TextAlign.center,
          ),


            )



        // Container(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: commonConfig.paddingY,
        //     vertical: commonConfig.paddingX,
        //   ),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).primaryColorLight.withOpacity(0.9),
        //     boxShadow: [
        //       if (commonConfig.boxShadow != null)
        //         BoxShadow(
        //           blurRadius: commonConfig.boxShadow!.blurRadius,
        //           color: Theme.of(context)
        //               .colorScheme
        //               .secondary
        //               .withOpacity(commonConfig.boxShadow!.colorOpacity),
        //           spreadRadius: commonConfig.boxShadow!.spreadRadius,
        //           offset: Offset(
        //               commonConfig.boxShadow!.x, commonConfig.boxShadow!.y),
        //         )
        //     ],
        //     borderRadius: BorderRadius.circular(commonConfig.radius ?? 0.0),
        //   ),
        //   child: Text(
        //     name ?? '',
        //     style: Theme.of(context)
        //         .textTheme
        //         .subtitle2
        //         ?.apply(fontSizeFactor: commonConfig.size ?? 1)
        //         .copyWith(fontSize: commonConfig.labelFontSize),
        //     maxLines: 2,
        //     textAlign: TextAlign.center,
        //   ),
        // ),
      ),
    );
  }
}
