import 'package:flutter/material.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/screens/patient/components/html_widget.dart';
import 'package:momona_healthcare/screens/patient/models/news_model.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class FeedDetailsScreen extends StatefulWidget {
  final NewsData? newsData;

  FeedDetailsScreen({this.newsData});

  @override
  _FeedDetailsScreenState createState() => _FeedDetailsScreenState();
}

class _FeedDetailsScreenState extends State<FeedDetailsScreen> {
  String postContent = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setPostContent(widget.newsData!.post_content.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> setPostContent(String text) async {
    postContent = widget.newsData!.post_content
        .validate()
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('[embed]', '<embed>')
        .replaceAll('[/embed]', '</embed>')
        .replaceAll('[caption]', '<caption>')
        .replaceAll('[/caption]', '</caption>');

    setState(() {});
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  Widget buildBodyWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Text(locale.lblNews, style: boldTextStyle(color: Colors.white, size: 10)),
                decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: primaryColor),
              ),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: textSecondaryColorGlobal, size: 10),
                  4.width,
                  Text(widget.newsData!.readable_date.validate(), style: secondaryTextStyle()),
                ],
              ),
            ],
          ),
          8.height,
          Text(parseHtmlString(widget.newsData!.post_title.validate()), style: boldTextStyle(size: 26)),
          HtmlWidget(postContent: postContent.validate()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "${parseHtmlString(widget.newsData!.post_title.validate())}",
        textColor: Colors.white,
        systemUiOverlayStyle: defaultSystemUiOverlayStyle(context),
      ),
      body: buildBodyWidget(),
    );
  }
}
