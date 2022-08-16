import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/entities/store_arguments.dart';
import '../../models/vendor/store_model.dart';
import '../common/start_rating.dart';

class StoreItem extends StatelessWidget {
  final Store? store;

  const StoreItem({this.store});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteList.storeDetail,
            arguments: StoreDetailArgument(store: store));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Theme.of(context).backgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 6,
              )
            ]),
        child: Column(
          children: [
            const SizedBox(height: 12),
            if (isNotBlank(store!.banner))
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: ImageTools.image(
                  url: store!.banner,
                  size: kSize.medium,
                  isResize: false,
                  fit: BoxFit.cover,
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Theme.of(context).backgroundColor,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          store!.name!,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        if (isNotBlank(store!.address))
                          const SizedBox(height: 3),
                        if (isNotBlank(store!.address))
                          Text(
                            store!.address!,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        /// WCFM store condition
                        if (store!.storeHour != null &&
                            store!.vacationSettings != null)
                          if (store!.vacationSettings!.vacationMode &&
                              store!.vacationSettings!.isOpen()) ...[
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: store!.storeHour!.isOpen()
                                      ? Colors.green
                                      : Colors.red,
                                  size: 12.0,
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Text(
                                  store!.storeHour!.isOpen()
                                      ? S.of(context).openNow
                                      : S.of(context).closeNow,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: store!.storeHour!.isOpen()
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 12.0),
                                ),
                              ],
                            ),
                          ],

                        /// Dokan store condition
                        if (store!.storeHour != null &&
                            store!.vacationSettings == null) ...[
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: store!.storeHour!.isOpen()
                                    ? Colors.green
                                    : Colors.red,
                                size: 12.0,
                              ),
                              const SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                store!.storeHour!.isOpen()
                                    ? S.of(context).openNow
                                    : S.of(context).closeNow,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: store!.storeHour!.isOpen()
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                        if (store!.vacationSettings != null &&
                            (store!.vacationSettings!.vacationMode &&
                                !store!.vacationSettings!.isOpen())) ...[
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Colors.red,
                                size: 12.0,
                              ),
                              const SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                S.of(context).onVacation,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: Colors.red, fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SmoothStarRating(
                          allowHalfRating: true,
                          starCount: 5,
                          rating: store!.rating ?? 0.0,
                          size: 15.0,
                          color: theme.primaryColor,
                          borderColor: theme.primaryColor,
                          label: const Text(''),
                          spacing: 0.0),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).visitStore,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle1!
                            .copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
