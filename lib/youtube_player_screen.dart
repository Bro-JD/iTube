import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';

class YouTubePlayerScreen extends StatefulWidget {
  const YouTubePlayerScreen({Key? key}) : super(key: key);

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;
  final TextEditingController _linkController = TextEditingController();
  String? _videoId;
  bool _enableCaptions = false;
  bool _isFullScreen = false;

  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();

    // Corrected onAppLink signature
    _appLinks = AppLinks(
      onAppLink: (Uri uri, String _) {
        _handleDeepLink(uri.toString());
      },
    );

    _initializeYouTubePlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _initializeYouTubePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: '', // Default video
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: _enableCaptions,
      ),
    );
  }

  void _handleDeepLink(String link) {
    final uri = Uri.parse(link);
    if (uri.host.contains('youtube.com') || uri.host == 'youtu.be') {
      final videoId = _extractVideoId(uri);
      if (videoId != null) {
        _updateVideoLink('https://youtu.be/$videoId');
      } else {
        _showError('Invalid YouTube link');
      }
    } else {
      _showError('Invalid link format');
    }
  }

  String? _extractVideoId(Uri uri) {
    String url = uri.toString();
    url = url.replaceAll(RegExp(r'(\?|\&)si=[^&]+'), ''); // Remove si param
    return YoutubePlayer.convertUrlToId(url);
  }

  void _updateVideoLink(String link) {
    setState(() {
      _linkController.text = link;
      _videoId = YoutubePlayer.convertUrlToId(link);
      if (_videoId != null) {
        _controller.load(_videoId!);
      }
    });
  }

  void _loadVideo() {
    final url = _linkController.text.trim();
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      setState(() {
        _videoId = videoId;
        _controller.load(videoId);
      });
    } else {
      _showError('Failed to load video. Please check the link.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleCaptions(bool? value) {
    setState(() => _enableCaptions = value ?? false);
  }

  void _toggleFullScreen(bool? value) {
    setState(() {
      _isFullScreen = value ?? false;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen ? null : _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _isFullScreen ? _buildExitFullScreenButton() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('YouTube Player'),
      actions: [
        IconButton(
          icon: const Icon(Icons.fullscreen_exit),
          onPressed: () => _toggleFullScreen(false),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: _isFullScreen ? Colors.black : Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(
          top: !_isFullScreen ? 16.0 : 0.0,
          bottom: !_isFullScreen ? 16.0 : 0.0,
        ),
        child: Column(
          children: [
            if (!_isFullScreen) ...[
              _buildLinkInput(),
              const SizedBox(height: 10),
              _buildLoadClearButtons(),
              const SizedBox(height: 20),
              _buildCaptionsAndFullscreenControls(),
              const SizedBox(height: 20),
            ],
            if (_videoId != null)
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkInput() {
    return TextField(
      controller: _linkController,
      decoration: const InputDecoration(
        labelText: 'Enter YouTube link',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLoadClearButtons() {
    return Row(
      children: [
        ElevatedButton(onPressed: _loadVideo, child: const Text('Load Video')),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _linkController.clear, child: const Text('Clear')),
      ],
    );
  }

  Widget _buildCaptionsAndFullscreenControls() {
    return Row(
      children: [
        Checkbox(value: _enableCaptions, onChanged: _toggleCaptions),
        const Text('Enable Captions'),
        const SizedBox(width: 20),
        Checkbox(value: _isFullScreen, onChanged: _toggleFullScreen),
        const Text('Full Screen'),
      ],
    );
  }

  Widget _buildExitFullScreenButton() {
    return FloatingActionButton(
      onPressed: () => _toggleFullScreen(false),
      child: const Icon(Icons.fullscreen_exit),
    );
  }
}
