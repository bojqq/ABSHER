import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';
import '../view_models/chat_view_model.dart' hide NavigationDestination;
import '../view_models/chat_view_model.dart' as chat show NavigationDestination;
import '../models/proactive_alert.dart';
import '../models/chat_message.dart';
import '../services/mlx_service.dart';
import '../services/mock_data_service.dart';
import '../extensions/color_absher.dart';
import '../extensions/font_absher.dart';

class AbsherChatView extends StatefulWidget {
  final List<ProactiveAlert> proactiveAlerts;

  const AbsherChatView({
    super.key,
    required this.proactiveAlerts,
  });

  static const String greetingText = 'مرحبا إلياس';

  @override
  State<AbsherChatView> createState() => _AbsherChatViewState();
}

class _AbsherChatViewState extends State<AbsherChatView> {
  late final ChatViewModel _viewModel;
  late final MLXService _mlxService;
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _mlxService = MLXService();
    _viewModel = ChatViewModel(
      mlxService: _mlxService,
      alertsProvider: () => widget.proactiveAlerts,
    );
    _viewModel.loadSuggestions();
    _mlxService.loadModel('models/sci3');
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleDeepLinkNavigation(DeepLink deepLink) {
    final destination = _viewModel.handleDeepLinkTap(deepLink);
    Navigator.of(context).pop();

    final appViewModel = context.read<AppViewModel>();
    switch (destination) {
      case chat.NavigationDestination.dependents:
        appViewModel.navigateToDependents();
        break;
      case chat.NavigationDestination.review:
        appViewModel.navigateToReview(serviceType: deepLink.serviceType);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_viewModel.messages.isEmpty) ...[
                    _buildGreetingSection(),
                    _buildSuggestionChipsSection(),
                  ] else
                    _buildMessagesListSection(),
                ],
              ),
            ),
          ),
          _buildBottomInputBar(),
          _buildBrandingBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.copy_all, color: Colors.grey),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF4285F4),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'إ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AbsherColors.green, AbsherColors.lightGreen],
            ).createShader(bounds),
            child: Text(
              AbsherChatView.greetingText,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'كيف أقدر اساعدك؟',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChipsSection() {
    if (_viewModel.suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _viewModel.suggestions.map((chip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => _viewModel.handleSuggestionTap(chip),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.notifications, size: 14, color: AbsherColors.orange),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      chip.displayText,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessagesListSection() {
    return Column(
      children: [
        ..._viewModel.messages.map((message) => _buildMessageView(message)),
        if (_viewModel.isProcessing) _buildLoadingIndicator(),
      ],
    );
  }

  Widget _buildMessageView(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser ? AbsherColors.green : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment:
                message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 15,
                  color: message.isUser ? Colors.white : const Color(0xFF1C1C1E),
                ),
                textAlign: message.isUser ? TextAlign.right : TextAlign.left,
              ),
              if (message.deepLink != null) ...[
                const SizedBox(height: 8),
                _buildDeepLinkButton(message.deepLink!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeepLinkButton(DeepLink deepLink) {
    return GestureDetector(
      onTap: () => _handleDeepLinkNavigation(deepLink),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AbsherColors.mint.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_forward_ios, size: 16, color: AbsherColors.mint),
            const SizedBox(width: 8),
            Text(
              deepLink.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AbsherColors.mint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: AbsherColors.green,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'جاري الكتابة...',
              style: AbsherFonts.caption.copyWith(color: AbsherColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      enabled: !_viewModel.isProcessing,
                      decoration: const InputDecoration(
                        hintText: 'اسأل أبشر',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16, color: Color(0xFF1C1C1E)),
                      textAlign: TextAlign.right,
                      onSubmitted: (_) => _sendMessage(),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  if (_inputController.text.isNotEmpty)
                    GestureDetector(
                      onTap: _sendMessage,
                      child: const Icon(
                        Icons.arrow_upward,
                        color: AbsherColors.green,
                        size: 24,
                      ),
                    )
                  else ...[
                    const Icon(Icons.mic, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    const Icon(Icons.camera_alt, color: Colors.grey, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_inputController.text.trim().isEmpty || _viewModel.isProcessing) return;
    _viewModel.inputText = _inputController.text;
    _inputController.clear();
    _viewModel.sendMessage();
  }

  Widget _buildBrandingBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 14, color: AbsherColors.green),
          const SizedBox(width: 6),
          Text(
            'أبشر',
            style: AbsherFonts.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
