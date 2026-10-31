import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/accessible_card.dart';
import '../../../data/repositories/app_providers.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

/// AI Teacher Screen: Friendly, patient multimodal assistant.
class AiTeacherScreen extends ConsumerStatefulWidget {
  final bool startWithVoice;

  const AiTeacherScreen({super.key, this.startWithVoice = false});

  @override
  ConsumerState<AiTeacherScreen> createState() => _AiTeacherScreenState();
}

class _AiTeacherScreenState extends ConsumerState<AiTeacherScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  bool _isLoading = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _activeSpokenText = '';

  final List<String> _suggestedQuestions = [
    'How do I use WhatsApp?',
    'How do I make a video call?',
    'How do I connect Wi-Fi?',
    'How do I use online banking?',
    'How do I send a photo?',
    'How do I identify a scam?',
  ];

  @override
  void initState() {
    super.initState();
    _addInitialGreeting();
    if (widget.startWithVoice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _toggleVoiceInput();
      });
    }
  }

  void _addInitialGreeting() {
    _messages.add(
      ChatMessage(
        text: 'Assalam-o-Alaikum! I am TechSaathi, your digital teacher. '
            'You can ask me any question about your phone, WhatsApp, or digital banking. '
            'I explain everything one step at a time, and we can practise together!',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    ref.read(ttsServiceProvider).stop();
    super.dispose();
  }

  void _scrollToBottom() {
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

  Future<void> _sendMessage(String query) async {
    final text = query.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
      _isLoading = true;
    });
    _scrollToBottom();

    final profile = ref.read(userProfileProvider);
    final ai = ref.read(aiServiceProvider);

    try {
      final answer = await ai.askTechnologyQuestion(
        text,
        language: profile.preferredLanguage,
      );

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(text: answer, isUser: false, timestamp: DateTime.now()));
          _isLoading = false;
        });
        _scrollToBottom();

        // If user prefers voice, automatically speak the answer
        if (profile.learningStyle != 'text') {
          await _speakText(answer);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'I am right here with you. Please try asking again or tap one of the suggested topics below.',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _toggleVoiceInput() async {
    final speech = ref.read(speechServiceProvider);

    if (_isListening) {
      await speech.stopListening();
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _isListening = true;
      });

      await speech.startListening(
        onResult: (words) {
          if (words.isNotEmpty) {
            _textController.text = words;
            if (!_isListening) {
              _sendMessage(words);
            }
          }
        },
      );
    }
  }

  Future<void> _speakText(String text) async {
    final tts = ref.read(ttsServiceProvider);
    final profile = ref.read(userProfileProvider);

    if (_isSpeaking && _activeSpokenText == text) {
      await tts.stop();
      setState(() {
        _isSpeaking = false;
        _activeSpokenText = '';
      });
    } else {
      setState(() {
        _isSpeaking = true;
        _activeSpokenText = text;
      });
      await tts.speak(text, languageCode: profile.preferredLanguage);
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('AI Teacher', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded),
            tooltip: 'Clear Conversation',
            onPressed: () {
              setState(() {
                _messages.clear();
                _addInitialGreeting();
              });
              ref.read(ttsServiceProvider).stop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Safety Advice',
            onPressed: _showTeacherGuideDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Suggested Questions Horizontal Scroller
            Container(
              height: 48,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestedQuestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final q = _suggestedQuestions[i];
                  return ActionChip(
                    backgroundColor: AppColors.secondaryTeal,
                    side: const BorderSide(color: AppColors.border),
                    avatar: const Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppColors.primaryBrand),
                    label: Text(
                      q,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBrand,
                      ),
                    ),
                    onPressed: () => _sendMessage(q),
                  );
                },
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final msg = _messages[i];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBrand),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'TechSaathi is writing step-by-step guidance...',
                            style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Voice Status Indicator
            if (_isListening)
              Container(
                color: const Color(0xFFFEF3C7),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.mic_rounded, color: AppColors.danger, size: 24),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Listening carefully... Speak your question now.',
                        style: TextStyle(color: Color(0xFF92400E), fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop_circle_rounded, color: AppColors.danger),
                      onPressed: _toggleVoiceInput,
                    ),
                  ],
                ),
              ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border, width: 1.2)),
              ),
              child: Row(
                children: [
                  // Voice Microphone Button (56x56 minimum touch target)
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: _isListening ? AppColors.danger : AppColors.secondaryTeal,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: _isListening ? Colors.white : AppColors.primaryBrand,
                        size: 28,
                      ),
                      tooltip: _isListening ? 'Stop listening' : 'Speak your question',
                      onPressed: _toggleVoiceInput,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Type your question...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded, color: AppColors.primaryBrand, size: 28),
                          tooltip: 'Send question',
                          onPressed: () => _sendMessage(_textController.text),
                        ),
                      ),
                      onSubmitted: _sendMessage,
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

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14, left: 40),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: const BoxDecoration(
            color: AppColors.primaryBrand,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              height: 1.35,
            ),
          ),
        ),
      );
    }

    // Teacher Bubble
    final hasPractice = msg.text.contains('Would you like to practise') ||
        msg.text.contains('پریکٹس کرنا چاہیں گے');

    return Container(
      margin: const EdgeInsets.only(bottom: 16, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.secondaryTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school_rounded, color: AppColors.primaryBrand, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AccessibleCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Voice Listen Button
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(120, 44),
                          side: const BorderSide(color: AppColors.primaryBrand),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: Icon(
                          _isSpeaking && _activeSpokenText == msg.text
                              ? Icons.stop_circle_rounded
                              : Icons.volume_up_rounded,
                          size: 20,
                          color: AppColors.primaryBrand,
                        ),
                        label: Text(
                          _isSpeaking && _activeSpokenText == msg.text ? 'Stop' : 'Listen',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBrand),
                        ),
                        onPressed: () => _speakText(msg.text),
                      ),

                      // Practice Button if prompted
                      if (hasPractice)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrand,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(140, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.touch_app_rounded, size: 18),
                          label: const Text('Practise Now', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => context.push('/practice-lab'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTeacherGuideDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism_rounded, color: AppColors.primaryBrand),
            SizedBox(width: 10),
            Text('TechSaathi Principles'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• We explain one step at a time with real-life analogies.'),
            SizedBox(height: 8),
            Text('• You can never break your phone by asking questions.'),
            SizedBox(height: 8),
            Text('• We never do everything for you — we teach you to do it independently.'),
            SizedBox(height: 8),
            Text('• Never share OTPs, PINs, or bank passwords with anyone.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}
