// ignore_for_file: avoid_print

import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/architecture/screens/architecture_selection_screen.dart';
import 'package:archflow/features/chat/presentation/providers/chat_provider.dart';
import 'package:archflow/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:archflow/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(chatProvider).messages.isEmpty) {
        _sendWelcomeMessage();
      }
    });
  }

  void _sendWelcomeMessage() {
    final chatState = ref.read(chatProvider);
    print('🟡 Chat Screen - ProjectId: ${chatState.projectId}');

    if (chatState.projectId == null || chatState.projectId!.isEmpty) {
      print('🔴 ERROR: No projectId found! Chat won\'t work.');
      return;
    }

    print('✅ ProjectId found: ${chatState.projectId}');

    ref
        .read(chatProvider.notifier)
        .sendMessage(
          'Hello! I just created my project. Can you help me with architecture and requirements?',
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text);
    _textController.clear();
    _scrollToBottom();
  }

  void _proceedToReview() {
    ref.read(chatProvider.notifier).clearChat();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ArchitectureSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(chatIsLoadingProvider);
    final currentPhase = ref.watch(chatPhaseProvider);
    final error = ref.watch(chatErrorProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(chatProvider.notifier).clearChat();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          // ✅ Removed elevation - uses theme
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            // ✅ Removed color - uses theme iconTheme
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
              ref.read(projectOnboardingProvider.notifier).previousStep();
            },
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  color: AppColors.brandGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AI Assistant',
                style: TextStyle(
                  // ✅ Fixed - uses theme
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: messages.length >= 2 ? _proceedToReview : null,
              icon: Icon(
                Icons.done,
                color: messages.length >= 2
                    ? AppColors.brandGreen
                    // ✅ Fixed - uses theme
                    : Theme.of(context).iconTheme.color?.withOpacity(0.3),
              ),
              label: Text(
                'Done',
                style: TextStyle(
                  color: messages.length >= 2
                      ? AppColors.brandGreen
                      // ✅ Fixed - uses theme
                      : Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: messages.length >= 2
                    ? AppColors.brandGreen.withOpacity(0.1)
                    : Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Phase indicator
              _buildPhaseIndicator(currentPhase),

              // Messages list
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState(isLoading)
                    : Stack(
                        children: [
                          ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                  milliseconds: 300 + (index * 50),
                                ),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: ChatMessageBubble(message: message),
                              );
                            },
                          ),

                          if (messages.length > 3)
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: FloatingActionButton.small(
                                onPressed: _scrollToBottom,
                                backgroundColor: AppColors.brandGreen,
                                child: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),

              // Error display
              if (error != null) _buildErrorBanner(error),

              // Loading indicator
              if (isLoading) _buildLoadingIndicator(),

              // Suggestion chips
              if (messages.isNotEmpty && !isLoading)
                _buildSuggestionChips(currentPhase),

              // Input field
              Container(
                decoration: BoxDecoration(
                  // ✅ Fixed - uses theme
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ChatInputField(
                    controller: _textController,
                    onSend: _sendMessage,
                    enabled: !isLoading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseIndicator(ChatPhase phase) {
    if (phase == ChatPhase.idle) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brandGreen.withOpacity(0.1),
            AppColors.brandGreen.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.brandGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brandGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(phase.icon, color: AppColors.brandGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phase.displayName,
                  style: TextStyle(
                    // ✅ Fixed - uses theme
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phase.description,
                  style: TextStyle(
                    // ✅ Fixed - uses theme
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool loading) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.brandGreen.withOpacity(0.2),
                    AppColors.brandGreen.withOpacity(0.1),
                  ],
                ),
              ),
              child: Icon(
                Icons.psychology_outlined,
                size: 64,
                color: AppColors.brandGreen,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'AI Requirements Assistant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                // ✅ Fixed - uses theme
                color: Theme.of(context).colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'I\'ll help you refine your requirements\nand suggest the best architecture',
              style: TextStyle(
                fontSize: 15,
                // ✅ Fixed - uses theme
                color: Theme.of(context).textTheme.bodyMedium?.color,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (loading)
              Column(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.brandGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Analyzing your project...',
                    style: TextStyle(
                      fontSize: 14,
                      // ✅ Fixed - uses theme
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: AppColors.brandGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Getting ready...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.brandGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: AppColors.error),
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
              _sendWelcomeMessage();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandGreen),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'AI is thinking...',
            style: TextStyle(
              // ✅ Fixed - uses theme
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips(ChatPhase phase) {
    final suggestions = _getSuggestions(phase);
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  if (suggestion == 'Continue to Review') {
                    _proceedToReview();
                  } else {
                    ref.read(chatProvider.notifier).sendMessage(suggestion);
                  }
                },
                // ✅ Fixed - uses theme
                backgroundColor: Theme.of(context).colorScheme.surface,
                side: BorderSide(color: AppColors.brandGreen.withOpacity(0.3)),
                labelStyle: TextStyle(
                  // ✅ Fixed - uses theme
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<String> _getSuggestions(ChatPhase phase) {
    switch (phase) {
      case ChatPhase.ideaDiscussion:
        return ['Who are the users?', 'Expected scale?', 'Any constraints?'];
      case ChatPhase.requirementGathering:
        return ['Tech stack?', 'Show architecture', 'Security concerns?'];
      case ChatPhase.architectureDesign:
        return ['Explain choice', 'Show alternatives'];
      default:
        return [];
    }
  }
}
