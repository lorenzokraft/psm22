import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../../../../common/tools.dart';
import '../../../../models/entities/blog.dart';

class BlogListItem extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;

  const BlogListItem({
    required this.blog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    if (blog.id == null) return const SizedBox();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(right: 15, left: 15),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child: ImageTools.image(
                url: blog.imageFeature,
                width: screenWidth,
                height: screenWidth * 0.5,
                fit: BoxFit.fitWidth,
                size: kSize.medium,
              ),
            ),
            SizedBox(
              height: 30,
              width: screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    blog.date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(width: 20.0),
                  if (blog.author.isNotEmpty)
                    Text(
                      blog.author.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        height: 2,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              blog.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 10.0),
            Text(
              blog.subTitle.isNotEmpty
                  ? parse(blog.subTitle).documentElement!.text
                  : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.3,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
