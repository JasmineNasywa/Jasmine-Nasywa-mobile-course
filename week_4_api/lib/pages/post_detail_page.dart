import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/network_errors.dart';
import '../data/providers.dart';
import '/data/models/post.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({
    super.key,
    required this.postId,
  });

  final int postId;

  @override
  ConsumerState<PostDetailPage> createState() =>
      _PostDetailPageState();
}

class _PostDetailPageState
    extends ConsumerState<PostDetailPage> {
  Post? post;
  Object? error;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadPost);
  }

  Future<void> _loadPost() async {
    final postsState = ref.read(postListProvider);

    // Coba ambil dari list yang sudah dimuat terlebih dahulu.
    Post? existingPost;

if (postsState.hasValue) {
  existingPost = postsState.value
      ?.where((post) => post.id == widget.postId)
      .firstOrNull;
}

    if (existingPost != null) {
      setState(() {
        post = existingPost;
        isLoading = false;
      });

      return;
    }

    // Kalau tidak ditemukan di list, ambil langsung dari repository.
    try {
      final repository = ref.read(postRepositoryProvider);
      final fetchedPost =
          await repository.fetchPost(widget.postId);

      if (!mounted) return;

      setState(() {
        post = fetchedPost;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Post'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            friendlyErrorMessage(error!),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (post == null) {
      return const Center(
        child: Text('Post tidak ditemukan.'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post!.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            post!.body,
            style: Theme.of(context)
                .textTheme
                .bodyLarge,
          ),
        ],
      ),
    );
  }
}