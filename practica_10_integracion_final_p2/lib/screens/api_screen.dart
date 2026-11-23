import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import '../widgets/state_views.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.instance.fetchPosts();
  }

  void _retry() => setState(() => _future = ApiService.instance.fetchPosts());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avisos de la comunidad')),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return ErrorView(message: snap.error.toString(), onRetry: _retry);
          }
          final posts = snap.data!;
          if (posts.isEmpty) {
            return const EmptyState(
                icon: Icons.campaign_outlined, message: 'Sin avisos.');
          }
          return RefreshIndicator(
            onRefresh: () async => _retry(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              itemBuilder: (_, i) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${posts[i].id}')),
                  title: Text(posts[i].title,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(posts[i].body,
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
