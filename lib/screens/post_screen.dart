import 'package:flutter/material.dart';

import '../apis/http_service.dart';
import '../models/post.dart';
import '../models/user.dart';

class PostScreen extends StatefulWidget {
  final User user;

  const PostScreen({super.key, required this.user});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<List<Post>> futurePosts;
  List<Post> posts = [];
  bool isLoading = false;
  int currentPage = 0;
  final int pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _fetchInitialPosts();
    _scrollController.addListener(_scrollListener);
  }

  void _fetchInitialPosts() {
    setState(() {
      futurePosts = fetchPosts(page: currentPage, limit: pageSize);
      futurePosts.then((newPosts) {
        setState(() {
          posts.clear();
          posts.addAll(newPosts);
        });
      });
    });
  }

  void _scrollListener() {
    // This condition checks if the user has scrolled to the bottom of the list
    // and if no loading operation is currently in progress.
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      _fetchMorePosts();
    }
  }

  void _fetchMorePosts() {
    setState(() {
      isLoading = true;
    });

    fetchPosts(page: currentPage + pageSize, limit: pageSize).then((newPosts) {
      setState(() {
        if (newPosts.isNotEmpty) {
          currentPage++;
          posts.addAll(newPosts);
        }

        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<List<Post>> fetchPosts({required int page, required int limit}) async {
    return HttpService.getAllPostByUserId(
        id: widget.user.id, skip: page, limit: limit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(57, 39, 97, 1),
      body: FutureBuilder(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.hasData || posts.isNotEmpty) {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                Post post = posts[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${post.id}'),
                    ),
                    title: Text(
                      post.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
