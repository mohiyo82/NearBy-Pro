import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../theme/app_theme.dart';

class HelpTutorialScreen extends StatefulWidget {
  const HelpTutorialScreen({super.key});

  @override
  State<HelpTutorialScreen> createState() => _HelpTutorialScreenState();
}

class _HelpTutorialScreenState extends State<HelpTutorialScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Make sure the file name matches exactly what you renamed it to
      _videoPlayerController = VideoPlayerController.asset('assets/video/nearby_video.mp4');

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        // Video ko uske original aspect ratio mein fit karne ke liye
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: Colors.grey.shade800,
          bufferedColor: AppColors.primary.withOpacity(0.3),
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ),
        autoInitialize: true,
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Video Player Error: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Video load nahi ho saki. Check karein ke file ka naam 'nearby_video.mp4' hai.";
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Nearby Pro Tutorial', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How to use Nearby Pro',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Watch this short guide to learn about our features.',
              style: TextStyle(fontSize: 14, color: AppColors.textGray),
            ),
            const SizedBox(height: 24),

            // Video Player Container with Dynamic Height based on Aspect Ratio
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _errorMessage != null
                    ? _buildErrorWidget()
                    : (_isInitialized && _chewieController != null
                        ? AspectRatio(
                            aspectRatio: _videoPlayerController!.value.aspectRatio,
                            child: Chewie(controller: _chewieController!),
                          )
                        : const SizedBox(
                            height: 220,
                            child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                          )),
              ),
            ),

            const SizedBox(height: 32),
            _buildInfoCard(),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                '© 2024 Nearby Pro - All Rights Reserved',
                style: TextStyle(fontSize: 12, color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.video_library_rounded, color: Colors.white54, size: 48),
          const SizedBox(height: 12),
          Text(_errorMessage!, style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _errorMessage = null;
                _isInitialized = false;
              });
              _initializePlayer();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 10),
              Text('About Nearby Pro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Nearby Pro is your ultimate companion for discovering local businesses and career opportunities. Watch the tutorial to see how to search, filter, and apply for jobs easily.',
            style: TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.6),
          ),
        ],
      ),
    );
  }
}
