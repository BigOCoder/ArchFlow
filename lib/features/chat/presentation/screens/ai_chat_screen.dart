import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/features/chat/presentation/providers/chat_provider.dart';
import 'package:archflow/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:archflow/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/shared/widgets/app_color.dart';
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

    // Initialize chat with project context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectState = ref.read(projectOnboardingProvider);

      // Set project context from onboarding data
      ref.read(chatProvider.notifier).setProjectContext(
        'temp-project-${DateTime.now().millisecondsSinceEpoch}',
        {
          'name': projectState.projectName,
          'category': projectState.category?.displayName ?? 'Unknown',
          'description': projectState.description,
          'problemStatement': projectState.problemStatement,
          'targetAudience': projectState.targetAudience,
          'proposedSolution': projectState.proposedSolution,
          'userType': projectState.primaryUserType?.displayName,
          'userScale': projectState.userScale?.displayName,
          'features': projectState.features
              .map(
                (f) => {
                  'name': f.name,
                  'description': f.description,
                  'priority': f.priority?.displayName,
                },
              )
              .toList(),
        },
      );

      // Add welcome message
      _sendWelcomeMessage();
    });
  }

  void _sendWelcomeMessage() {
    final projectState = ref.read(projectOnboardingProvider);

    final summary =
        '''
I'm working on a project called "${projectState.projectName}".

Category: ${projectState.category?.displayName ?? 'Not specified'}
Description: ${projectState.description}

Problem Statement: ${projectState.problemStatement}
Target Audience: ${projectState.targetAudience}
Proposed Solution: ${projectState.proposedSolution}

Can you help me refine the requirements and suggest an architecture?
''';

    ref.read(chatProvider.notifier).sendMessage(summary);
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
    ref.read(projectOnboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(chatIsLoadingProvider);
    final currentPhase = ref.watch(chatPhaseProvider);
    final error = ref.watch(chatErrorProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
          ),
          onPressed: () {
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
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          // Transparent Done button
          TextButton.icon(
            onPressed: messages.length >= 2 ? _proceedToReview : null,
            icon: Icon(
              Icons.done,
              color: messages.length >= 2
                  ? AppColors.brandGreen
                  : (isDark ? AppColors.darkIcon : AppColors.lightIcon)
                        .withOpacity(0.3),
            ),
            label: Text(
              'Done',
              style: TextStyle(
                color: messages.length >= 2
                    ? AppColors.brandGreen
                    : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary)
                          .withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: messages.length >= 2
                  ? AppColors.brandGreen.withOpacity(0.1)
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            _buildPhaseIndicator(currentPhase, isDark),

            // Messages list
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState(isDark, isLoading)
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

                        // Scroll to bottom button
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
            if (error != null) _buildErrorBanner(error, isDark),

            // Loading indicator
            if (isLoading) _buildLoadingIndicator(isDark),

            // Suggestion chips
            if (messages.isNotEmpty && !isLoading)
              _buildSuggestionChips(currentPhase, isDark),

            // Input field
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
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
    );
  }

  Widget _buildPhaseIndicator(ChatPhase phase, bool isDark) {
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
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phase.description,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
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

  Widget _buildEmptyState(bool isDark, bool loading) {
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
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'I\'ll help you refine your requirements\nand suggest the best architecture',
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
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
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
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

  Widget _buildErrorBanner(String error, bool isDark) {
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

  Widget _buildLoadingIndicator(bool isDark) {
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
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChips(ChatPhase phase, bool isDark) {
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
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                side: BorderSide(color: AppColors.brandGreen.withOpacity(0.3)),
                labelStyle: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
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
