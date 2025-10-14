import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recova/models/post_model.dart';
import 'package:recova/bloc/community_cubit.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String _selectedFilter = "Nasihat";
  final List<String> _filters = const ["Nasihat", "Bantuan", "Motivasi"];

  @override
  void initState() {
    super.initState();
    // Panggil fetchPosts saat halaman pertama kali dimuat
    context.read<CommunityCubit>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    // Widget ini hanya mengembalikan kontennya, tanpa Scaffold atau SafeArea.
    // Padding atas ditambahkan untuk ruang di bawah status bar.
    return RefreshIndicator(
      onRefresh: () => context.read<CommunityCubit>().fetchPosts(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column( // Column dipertahankan karena strukturnya sudah benar
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Komunitas",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
              ],
            ),
            const SizedBox(height: 20),
    
            // Filter Buttons
            Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FilterChipWidget(
                    label: filter,
                    selected: _selectedFilter == filter,
                    onSelected: (isSelected) {
                      if (isSelected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
    
            // Posts List
            Expanded(
              child: BlocBuilder<CommunityCubit, CommunityState>(
                builder: (context, state) {
                  if (state is CommunityLoading && state is! CommunityLoadSuccess) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is CommunityLoadFailure) {
                    return Center(child: Text('Gagal memuat postingan: ${state.error}'));
                  }
                  if (state is CommunityLoadSuccess) {
                    final allPosts = state.posts.map((p) => p.toPostCardMap()).toList();
                    final filteredPosts = allPosts.where((post) => post['category'] == _selectedFilter).toList();
    
                    if (filteredPosts.isEmpty) {
                      return Center(child: Text('Belum ada postingan di kategori ini.'));
                    }
    
                    return ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        final postId = post['id'] as String;
                        return PostCard(
                          id: postId,
                          username: post['username'] ?? 'Anonim', // Memberikan nilai default jika null
                          likes: post['likes'] ?? 0, // Memberikan nilai default jika null
                          text: post['text'] ?? '', // Memberikan nilai default jika null
                          streak: post['streak'] ?? 0, // Memberikan nilai default jika null
                          isLiked: post['isLiked'] ?? false,
                          onLikePressed: () {
                            context.read<CommunityCubit>().toggleLike(postId);
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: Text('Belum ada postingan.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Widgets
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const FilterChipWidget({super.key, required this.label, this.selected = false, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: Colors.teal.shade100,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: selected ? Colors.teal : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      onSelected: onSelected,
    );
  }
}

class PostCard extends StatelessWidget {
  final String id;
  final String username;
  final int likes;
  final String text;
  final int streak;
  final bool isLiked;
  final VoidCallback onLikePressed;

  const PostCard({
    super.key,
    required this.id,
    required this.username,
    required this.likes,
    required this.text,
    required this.streak,
    required this.isLiked,
    required this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 6),
                Text(username,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "$streak",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.local_fire_department,
                          size: 14, color: Colors.orange),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onLikePressed,
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text("$likes",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}