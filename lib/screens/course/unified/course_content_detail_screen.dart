import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:madressa_learning_platform/models/lecture_model.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseContentDetailScreen extends StatefulWidget {
  final dynamic course;
  final String userId;

  const CourseContentDetailScreen({
    Key? key,
    required this.course,
    required this.userId,
  }) : super(key: key);

  @override
  State<CourseContentDetailScreen> createState() =>
      _CourseContentDetailScreenState();
}

class _CourseContentDetailScreenState extends State<CourseContentDetailScreen>
    with SingleTickerProviderStateMixin {
  late List<bool> completionStatus;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    completionStatus = List<bool>.filled(widget.course.lectures.length, false);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = completionStatus.where((status) => status).length;
    final progress =
        widget.course.lectures.isEmpty
            ? 0.0
            : completedCount / widget.course.lectures.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(progress, completedCount),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProgressSection(progress, completedCount),
                _buildTabBar(),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [_buildStreamTab(), _buildClassworkTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(double progress, int completedCount) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF1967D2),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.course.imageUrl),
            ),
            gradient: LinearGradient(
              colors: [const Color(0xFF1967D2), const Color(0xFF1557B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.course.title,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.course.teacherId,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(double progress, int completedCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course Progress',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1967D2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF1967D2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$completedCount of ${widget.course.lectures.length} lectures completed',
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1967D2),
        unselectedLabelColor: Colors.grey.shade600,
        indicatorColor: const Color(0xFF1967D2),
        indicatorWeight: 3,
        labelStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [Tab(text: 'Stream'), Tab(text: 'Classwork')],
      ),
    );
  }

  Widget _buildStreamTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAnnouncementCard(
          'Welcome to ${widget.course.title}!',
          'Start your learning journey by exploring the course materials.',
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        const SizedBox(height: 16),
        _buildAnnouncementCard(
          'Course Materials Updated',
          'New lecture materials have been added to the course.',
          DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard(String title, String message, DateTime date) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF1967D2),
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.teacherId,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    Text(
                      _formatDate(date),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassworkTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.course.lectures.length,
      itemBuilder: (context, index) {
        final lecture = widget.course.lectures[index];
        final isCompleted = completionStatus[index];
        return _buildLectureCard(lecture, index, isCompleted);
      },
    );
  }

  Widget _buildLectureCard(dynamic lecture, int index, bool isCompleted) {
    // Determine icon, color, type for visual cue (only use icon in leading)
    IconData icon;
    switch (lecture.type) {
      case LectureType.video:
        icon = Icons.play_circle_filled;
        break;
      case LectureType.pdf:
        icon = Icons.picture_as_pdf;
        break;
      case LectureType.image:
        icon = Icons.image;
        break;
      case LectureType.doc:
      default:
        icon = Icons.description;
        break;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: isCompleted ? 2 : 0.5,
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Icon(
            icon,
            size: 34,
            color: isCompleted ? const Color(0xFF4CAF50) : Colors.grey.shade400,
          ),
          title: Text(
            lecture.title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    lecture.type.toString().split('.').last,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Lecture ${index + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          trailing:
              isCompleted
                  ? const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 22,
                  )
                  : const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
          onTap: () {
            setState(() => completionStatus[index] = true);
            _showLectureDialog(context, lecture);
          },
        ),
      ),
    );
  }

  void _showLectureDialog(BuildContext context, dynamic lecture) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lecture.title,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLectureDialogContent(lecture),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1967D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildLectureDialogContent(dynamic lecture) {
    switch (lecture.type) {
      case LectureType.video:
        return _buildVideoPlayer(lecture.resourceUrl);
      case LectureType.pdf:
      case LectureType.doc:
        return _buildDocumentViewer(lecture.title, lecture.resourceUrl);
      case LectureType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            lecture.resourceUrl,
            height: 300,
            fit: BoxFit.contain,
            errorBuilder:
                (_, __, ___) => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 60),
                  ),
                ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildVideoPlayer(String url) {
    return SizedBox(height: 250, child: _ChewiePlayerWidget(videoUrl: url));
  }

  Widget _buildDocumentViewer(String title, String url) {
    final displayName = title.isNotEmpty ? title : url.split('/').last;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.picture_as_pdf,
            size: 80,
            color: const Color(0xFFFF5722),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          icon: const Icon(Icons.download),
          label: const Text('Download / Open'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1967D2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _ChewiePlayerWidget extends StatefulWidget {
  final String videoUrl;
  const _ChewiePlayerWidget({required this.videoUrl});
  @override
  State<_ChewiePlayerWidget> createState() => _ChewiePlayerWidgetState();
}

class _ChewiePlayerWidgetState extends State<_ChewiePlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: 16 / 9,
      errorBuilder: (context, errorMessage) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 14),
            Text(
              'This video could not be played.\nReason: Format not supported by your browser.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(widget.videoUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Download/Open Video'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1967D2),
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: _chewieController!);
  }
}
