import 'dart:async';

import 'package:flutter/material.dart';
import 'package:posts_app/models/data_model.dart';
import 'package:posts_app/screens/home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>()
        ..fetchData()
        ..listenScrollBottom();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text(
          'Posts App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[400],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) {
            if (model.dataModel == null) {
              return const CircularProgressIndicator();
            } else {
              return _listWidget(model);
            }
          },
        ),
      )),
    );
  }

  ListView _listWidget(HomeViewModel model) {
    final List<Post> posts = model.dataModel!.posts;
    return ListView.builder(
      controller: model.scrollController,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final Post item = posts[index];
        return Card(
          elevation: 4,
          color: Colors.white70,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.body,
                            style:
                                Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.thumb_up, color: Colors.green),
                        const SizedBox(width: 4),
                        Text("${item.reactions.likes}"),
                        const SizedBox(width: 16),
                        Icon(Icons.thumb_down, color: Colors.red),
                        const SizedBox(width: 4),
                        Text("${item.reactions.dislikes}"),
                      ],
                    ),
                    // Görüntülenme sayısı
                    Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${item.views} görüntülenme"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
