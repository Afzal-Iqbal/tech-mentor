import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../data/models/scam_analysis_result.dart';
import '../../data/models/screen_explanation.dart';

/// TechSaathi AI Engine powering AI Teacher, Screen Explainer, and ScamShield.
class AiService {
  final String? apiKey;
  GenerativeModel? _model;

  AiService({this.apiKey}) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      try {
        _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey!,
          systemInstruction: Content.system(
            'You are TechSaathi, a patient, warm, and highly supportive digital technology teacher for older adults and digital beginners. '
            'Always explain one step at a time, use real-life analogies, never make users feel unintelligent, '
            'provide safety advice, and always conclude with: "Would you like to practise this yourself?"',
          ),
        );
      } catch (e) {
        debugPrint('AiService model initialization note: $e');
      }
    }
  }

  /// AI Teacher: Answer technology question with step-by-step guidance.
  Future<String> askTechnologyQuestion(String question, {String language = 'ur-roman'}) async {
    final cleanQ = question.trim().toLowerCase();

    // If online model is ready, query Gemini
    if (_model != null) {
      try {
        final prompt = 'User question: "$question". Respond in ${language == "ur" ? "Urdu" : language == "ur-roman" ? "Roman Urdu" : "English"}. '
            'Provide: Friendly greeting, Step 1, Step 2, Step 3, Safety Tip, and "Would you like to practise this yourself?"';
        final response = await _model!.generateContent([Content.text(prompt)]);
        if (response.text != null && response.text!.isNotEmpty) {
          return response.text!;
        }
      } catch (e) {
        debugPrint('Gemini live call error, using local expert fallback: $e');
      }
    }

    // High fidelity offline fallback engine tailored for older adults
    return _generateLocalAiResponse(cleanQ, language);
  }

  /// ScamShield: Analyze SMS / WhatsApp messages for fraud.
  Future<ScamAnalysisResult> analyzeSuspiciousMessage(String message) async {
    final text = message.toLowerCase();

    // Check threat and scam heuristics
    final hasOtp = text.contains('otp') ||
        text.contains('code') ||
        text.contains('pin') ||
        text.contains('password') ||
        text.contains('کوڈ') ||
        text.contains('پاس ورڈ');

    final hasPrize = text.contains('won') ||
        text.contains('lottery') ||
        text.contains('prize') ||
        text.contains('bisp') ||
        text.contains('ehsaas') ||
        text.contains('car') ||
        text.contains('انعام') ||
        text.contains('لاٹری') ||
        text.contains('مبارک');

    final hasUrgency = text.contains('block') ||
        text.contains('urgent') ||
        text.contains('suspend') ||
        text.contains('immediately') ||
        text.contains('10 min') ||
        text.contains('بلاک') ||
        text.contains('فوری') ||
        text.contains('بند');

    final hasLink = text.contains('http') ||
        text.contains('.ly') ||
        text.contains('.com') ||
        text.contains('bit.ly') ||
        text.contains('wa.me');

    if (hasOtp || (hasPrize && hasUrgency) || (hasUrgency && hasLink)) {
      return ScamAnalysisResult(
        riskLevel: ScamRiskLevel.highRisk,
        warningSigns: [
          'Direct request for secret verification code (OTP / PIN)',
          'High psychological urgency claiming immediate account closure',
          'Unsolicited prize or financial reward claim',
          'Unknown sender using an unofficial mobile number',
        ],
        warningSignsUrdu: [
          'خفیہ او ٹی پی یا پن کوڈ مانگنے کی کوشش',
          'اکاؤنٹ فوری بلاک ہونے کی جھوٹی دھمکی',
          'بغیر لاٹری کھیلے لاکھوں کے انعام کا جھوٹا دعویٰ',
          'غیر سرکاری اور انجان موبائل نمبر سے پیغام',
        ],
        explanation:
            'This message shows extreme indicators of financial fraud. Legitimate banks and government programs (like BISP) NEVER ask for OTP passwords or send prize claims from random cell phone numbers.',
        explanationUrdu:
            'یہ پیغام مالی فراڈ کی واضح علامات دکھاتا ہے۔ کوئی بھی اصل بینک یا حکومتی ادارہ کبھی ایس ایم ایس پر پاس ورڈ نہیں مانگتا اور نہ عام نمبروں سے انعامات بانٹتا ہے۔',
        recommendedAction:
            'DO NOT reply. DO NOT share any code. DO NOT tap any links. Delete this message immediately and call your bank helpline if concerned.',
        recommendedActionUrdu:
            'کوئی جواب نہ دیں، کوئی کوڈ نہ بتائیں، اور کسی لنک پر کلک نہ کریں۔ پیغام کو فوراً ڈیلیٹ کر دیں۔',
        detectedIndicators: [
          if (hasOtp) 'OTP / PIN Request Detected',
          if (hasPrize) 'Unsolicited Prize / BISP Claim',
          if (hasUrgency) 'Urgent Threat of Account Suspension',
          if (hasLink) 'Unverified Web Link',
        ],
      );
    } else if (hasPrize || hasUrgency || hasLink) {
      return ScamAnalysisResult(
        riskLevel: ScamRiskLevel.suspicious,
        warningSigns: [
          'Urgent language or unsolicited offer',
          'Suspicious link from an unverified source',
          'Unusual request for action',
        ],
        warningSignsUrdu: [
          'پراسرار لنک یا جلدی مچانے والا لہجہ',
          'غیر مصدقہ ذریعے سے آنے والا میسج',
        ],
        explanation:
            'This message contains suspicious indicators. Be cautious and verify independently through official family or company phone numbers before taking action.',
        explanationUrdu:
            'یہ پیغام مشکوک دکھائی دیتا ہے۔ کوئی بھی قدم اٹھانے سے پہلے اپنے گھر والوں یا متعلقہ ادارے کے اصل نمبر پر تصدیق کریں۔',
        recommendedAction:
            'Do not tap on the link. Call the official helpline directly from the number printed on your utility bill or bank card.',
        recommendedActionUrdu:
            'کسی لنک پر کلک نہ کریں۔ اپنے بل یا کارڈ کے پیچھے لکھے اصل نمبر پر کال کر کے معلوم کریں۔',
        detectedIndicators: [
          if (hasPrize) 'Prize Mention',
          if (hasUrgency) 'Urgent Language',
          if (hasLink) 'Embedded Link',
        ],
      );
    } else {
      return const ScamAnalysisResult(
        riskLevel: ScamRiskLevel.low,
        warningSigns: [
          'Standard text format without blatant scam keywords',
        ],
        warningSignsUrdu: [
          'عام پیغام، فوری خطرے کی واضح علامات موجود نہیں',
        ],
        explanation:
            'While this specific text does not contain common threat words, remember: no message can be guaranteed 100% safe. Always verify senders.',
        explanationUrdu:
            'اگرچہ اس پیغام میں چوری کے عام الفاظ نہیں ہیں، لیکن یاد رکھیں کوئی بھی پیغام سو فیصد محفوظ نہیں ہوتا، ہمیشہ محتاط رہیں۔',
        recommendedAction:
            'If this message involves money or account changes, always call the sender directly on their known phone number.',
        recommendedActionUrdu:
            'اگر یہ پیغام پیسوں کے متعلق ہو تو بھیجنے والے کے اصل نمبر پر کال کر کے تصدیق کریں۔',
        detectedIndicators: ['Standard Text'],
      );
    }
  }

  /// Explain My Screen: Breakdown of confusing screenshots.
  Future<ScreenExplanationResult> explainScreenshot({
    Uint8List? imageBytes,
    String screenType = 'bank_transfer',
  }) async {
    // If Gemini vision model is connected with bytes:
    if (_model != null && imageBytes != null) {
      try {
        const prompt = 'Analyze this smartphone screen for an elderly beginner user. '
            'Break it down into: Screen Name, What is this screen, 3 Button Meanings, Things to watch out for, and the single safest next step.';
        final content = [
          Content.multi([
            TextPart(prompt),
            DataPart('image/jpeg', imageBytes),
          ]),
        ];
        final response = await _model!.generateContent(content);
        if (response.text != null && response.text!.isNotEmpty) {
          // Parse or return friendly structured output
        }
      } catch (e) {
        debugPrint('Gemini vision call note: $e');
      }
    }

    // Robust preset explainer scenarios for comprehensive interactive demonstration
    if (screenType == 'whatsapp_call') {
      return const ScreenExplanationResult(
        screenName: 'Incoming WhatsApp Video Call',
        screenNameUrdu: 'واٹس ایپ پر آنے والی ویڈیو کال',
        whatIsThisScreen:
            'A family member or friend is calling your phone on video so they can see and speak with you live.',
        whatIsThisScreenUrdu:
            'کوئی عزیز آپ کو ویڈیو کال ملا رہے ہیں تاکہ وہ آپ کو دیکھ سکیں اور بات کر سکیں۔',
        buttonMeanings: [
          ButtonExplanation(
            buttonName: 'Green Phone Icon (Swipe Up / Tap)',
            meaning: 'Accepts the call so you can start talking immediately.',
            meaningUrdu: 'کال اٹھانے کے لیے، اس کو دبائیں تو بات شروع ہو جائے گی۔',
            isSafe: true,
          ),
          ButtonExplanation(
            buttonName: 'Red Phone Icon',
            meaning: 'Declines or ends the call if you are busy or praying.',
            meaningUrdu: 'اگر آپ مصروف ہیں یا نماز پڑھ رہے ہیں تو کال کاٹنے کے لیے۔',
            isSafe: true,
          ),
          ButtonExplanation(
            buttonName: 'Message Icon',
            meaning: 'Sends a polite quick text saying "I will call you later".',
            meaningUrdu: 'میسج بھیجنے کے لیے کہ "میں بعد میں کال کرتا ہوں"۔',
            isSafe: true,
          ),
        ],
        whatYouCanDo:
            'You can answer by tapping or swiping up the green button, or decline with the red button.',
        whatYouCanDoUrdu:
            'آپ سبز بٹن سے کال اٹھا سکتے ہیں یا لال بٹن سے کاٹ سکتے ہیں۔',
        thingsToWatchOut:
            'If the screen shows an unknown international phone number you do not recognize, it is safest to tap the Red button.',
        thingsToWatchOutUrdu:
            'اگر کال کسی انجان نمبر سے آ رہی ہو جسے آپ نہ جانتے ہوں تو لال بٹن دبا کر کاٹ دیں۔',
        nextSafeStep:
            'Look at the caller name. If it is your child or relative, tap the Green button.',
        nextSafeStepUrdu:
            'کال کرنے والے کا نام دیکھیں۔ اگر وہ آپ کا بچہ یا عزیز ہے تو سبز بٹن دبائیں۔',
      );
    } else if (screenType == 'otp_sms') {
      return const ScreenExplanationResult(
        screenName: 'Bank OTP Verification SMS',
        screenNameUrdu: 'بینک کا او ٹی پی (OTP) میسج',
        whatIsThisScreen:
            'Your bank has sent a temporary one-time password code to confirm an action.',
        whatIsThisScreenUrdu:
            'آپ کے بینک نے تصدیق کے لیے ایک وقتی خفیہ کوڈ بھیجا ہے۔',
        buttonMeanings: [
          ButtonExplanation(
            buttonName: 'Copy Code Button',
            meaning: 'Copies the 6 digits so you can paste them into your bank app.',
            meaningUrdu: 'کوڈ کاپی کرنے کے لیے تاکہ بینک ایپ میں پیسٹ کیا جا سکے۔',
            isSafe: true,
          ),
          ButtonExplanation(
            buttonName: 'Delete Message',
            meaning: 'Removes the SMS after you have finished your payment.',
            meaningUrdu: 'کام مکمل ہونے کے بعد میسج ڈیلیٹ کرنے کے لیے۔',
            isSafe: true,
          ),
        ],
        whatYouCanDo:
            'Only enter this code into the official bank app that YOU opened yourself.',
        whatYouCanDoUrdu:
            'یہ کوڈ صرف اسی وقت استعمال کریں جب آپ خود کوئی بل ادا کر رہے ہوں۔',
        thingsToWatchOut:
            'CRITICAL SAFETY WARNING: NEVER read or send this code to anyone on a phone call or WhatsApp message.',
        thingsToWatchOutUrdu:
            'اہم ترین تنبیہ: فون کال یا واٹس ایپ پر یہ کوڈ کبھی کسی کو نہ بتائیں۔',
        nextSafeStep:
            'If you did not initiate this payment, call your bank helpline immediately to lock your card.',
        nextSafeStepUrdu:
            'اگر آپ نے کوئی ادائیگی نہیں کی اور یہ کوڈ آ گیا تو فوراً بینک ہیلپ لائن پر کال کریں۔',
      );
    } else {
      // Default: Banking Transfer Review Screen
      return const ScreenExplanationResult(
        screenName: 'Bank Transfer Review Screen',
        screenNameUrdu: 'رقم ٹرانسفر کا ریویو (Review) پیج',
        whatIsThisScreen:
            'This is the final confirmation page before money leaves your account. It shows who will receive the money and how much.',
        whatIsThisScreenUrdu:
            'یہ رقم بھیجنے سے پہلے آخری سکرین ہے، جس پر رقم اور وصول کنندہ کا نام لکھا ہوتا ہے۔',
        buttonMeanings: [
          ButtonExplanation(
            buttonName: 'Confirm / Pay Now',
            meaning: 'Authorizes the transfer and sends the money immediately.',
            meaningUrdu: 'اس بٹن سے رقم فوراً دوسرے اکاؤنٹ میں چلی جائے گی۔',
            isSafe: true,
          ),
          ButtonExplanation(
            buttonName: 'Back / Cancel Arrow',
            meaning: 'Returns you back without sending any money.',
            meaningUrdu: 'بغیر کوئی رقم بھیجے پیچھے واپس چلے جائیں۔',
            isSafe: true,
          ),
          ButtonExplanation(
            buttonName: 'Fee / Charges (PKR 0.00)',
            meaning: 'Shows if there is any fee for this transaction.',
            meaningUrdu: 'یہ دکھاتا ہے کہ اس ٹرانسفر پر کوئی فیس تو نہیں لگ رہی۔',
            isSafe: true,
          ),
        ],
        whatYouCanDo:
            'Calmly read the recipient name and verify the amount in rupees before doing anything.',
        whatYouCanDoUrdu:
            'اطمینان سے وصول کنندہ کا نام اور رقم کے ہندسے پڑھیں۔',
        thingsToWatchOut:
            'Make sure the recipient name matches your intended friend or relative. Check that there are no accidental extra zeros in the amount.',
        thingsToWatchOutUrdu:
            'نام اور رقم دھیان سے دیکھ لیں، کوئی اضافی صفر نہ لگا ہو۔',
        nextSafeStep:
            'If both the name and amount are correct, tap "Confirm Transfer". If not, tap Cancel.',
        nextSafeStepUrdu:
            'اگر نام اور رقم بالکل ٹھیک ہیں تو کنفرم دبائیں، ورنہ کینسل کر دیں۔',
      );
    }
  }

  /// Local AI Teacher Knowledge Base with step-by-step guidance.
  String _generateLocalAiResponse(String question, String language) {
    if (question.contains('whatsapp') || question.contains('واٹس ایپ')) {
      if (language == 'ur') {
        return 'السلام علیکم! واٹس ایپ استعمال کرنا بہت آسان ہے۔ آئیے مل کر سیکھتے ہیں:\n\n'
            '• ہم کیا کرنے جا رہے ہیں: واٹس ایپ پر اپنے بچوں کو میسج اور تصویر بھیجنا۔\n\n'
            'قدم نمبر ۱: اپنی فون کی سکرین پر سبز رنگ کا واٹس ایپ آئیکن دبائیں۔\n'
            'قدم نمبر ۲: جس عزیز سے بات کرنی ہو، ان کے نام پر انگلی رکھیں۔\n'
            'قدم نمبر ۳: نیچے دائیں کونے میں سبز مائیکروفون کا نشان دبا کر رکھیں اور اپنی بات بول کر انگلی اٹھا لیں۔\n\n'
            'اہم حفاظتی مشورہ: کسی انجان نمبر سے آنے والے نیلے لنکس پر کلک نہ کریں۔\n\n'
            'کیا آپ اس کی خود پریکٹس کرنا چاہیں گے؟';
      } else if (language == 'ur-roman') {
        return 'Assalam-o-Alaikum! WhatsApp chalana bohat aasan hai. Aayein mil kar seekhte hain:\n\n'
            '• Hum kya karne ja rahe hain: Apne bachon ko WhatsApp par aawaz aur tasweer bhejna.\n\n'
            'Step 1: Phone screen par sabz rang ka WhatsApp icon tap karein.\n'
            'Step 2: Apne rishtedaar ya bache ke naam par tap karein.\n'
            'Step 3: Neeche right corner mein sabz microphone ka button daba kar rakhein, apni baat kahein, aur ungli utha lein.\n\n'
            'Zaroori Hifazati Mashwara: Kisi anjaan shakhs ke bheje hue link par kabhi click na karein.\n\n'
            'Would you like to practise this yourself?';
      } else {
        return 'Assalam-o-Alaikum! Using WhatsApp is very simple and joyful. Let us learn together:\n\n'
            '• What we are going to do: Send a friendly voice message without typing.\n\n'
            'Step 1: Tap the green WhatsApp icon on your phone home screen.\n'
            'Step 2: Tap the name of the child or family member you want to talk to.\n'
            'Step 3: Press and HOLD the green microphone button at the bottom right. Speak clearly, then lift your finger to send.\n\n'
            'Important Safety Advice: Never tap unknown blue links sent by people you do not recognize.\n\n'
            'Would you like to practise this yourself?';
      }
    } else if (question.contains('video') || question.contains('ویڈیو')) {
      return 'Assalam-o-Alaikum! Making a video call connects you with your loved ones face-to-face:\n\n'
          '• What we are going to do: Start a video call on WhatsApp.\n\n'
          'Step 1: Open WhatsApp and tap the person you want to see.\n'
          'Step 2: Look at the top right corner and tap the small Video Camera icon.\n'
          'Step 3: Hold the phone at eye level. When finished, tap the Red telephone button to hang up.\n\n'
          'Important Safety Advice: Only accept video calls from family members you recognize.\n\n'
          'Would you like to practise this yourself?';
    } else if (question.contains('wifi') || question.contains('internet') || question.contains('انٹرنیٹ')) {
      return 'Assalam-o-Alaikum! Connecting to home Wi-Fi is easy:\n\n'
          '• What we are going to do: Connect your phone to your home internet.\n\n'
          'Step 1: Swipe your finger down from the very top of your screen to open quick settings.\n'
          'Step 2: Look for the fan-shaped Wi-Fi icon and press it gently.\n'
          'Step 3: Tap your home network name and enter the password given by your family.\n\n'
          'Important Safety Advice: Avoid doing banking on free open Wi-Fi in train stations or parks.\n\n'
          'Would you like to practise this yourself?';
    } else if (question.contains('bank') || question.contains('money') || question.contains('پیسے') || question.contains('بینک')) {
      return 'Assalam-o-Alaikum! Online banking gives you freedom from branch queues:\n\n'
          '• What we are going to do: Send money safely using your banking app.\n\n'
          'Step 1: Open your bank app with your fingerprint or secret passcode.\n'
          'Step 2: Tap "Send Money" or "Transfer" and choose your saved beneficiary.\n'
          'Step 3: Enter the amount in rupees, and carefully read the Review screen before pressing confirm.\n\n'
          'Important Safety Advice: NEVER tell your 6-digit SMS code or ATM PIN to anyone calling you.\n\n'
          'Would you like to practise this yourself in the TechSaathi Demo Bank?';
    } else if (question.contains('scam') || question.contains('فراڈ') || question.contains('fake')) {
      return 'Assalam-o-Alaikum! Protecting yourself from scammers is easy with one golden rule:\n\n'
          '• What we are going to do: Identify fake messages and lottery phone calls.\n\n'
          'Step 1: Remember that no real bank will ever ask you for your SMS OTP code.\n'
          'Step 2: If someone claims you won a car or lottery in a contest you never entered, it is 100% fake.\n'
          'Step 3: If in doubt, hang up immediately and ask your children or visit the bank branch.\n\n'
          'Important Safety Advice: Use our ScamShield tab anytime you receive a message that makes you feel uneasy.\n\n'
          'Would you like to practise this yourself?';
    } else {
      return 'Assalam-o-Alaikum! I am TechSaathi, your personal digital teacher. I am right here with you.\n\n'
          '• What we are going to do: Learn step-by-step without any rush.\n\n'
          'Step 1: Tell me what task you would like to do (e.g., paying a bill, making a video call, or sending a photo).\n'
          'Step 2: We will break it down into simple, easy actions with real-life examples.\n'
          'Step 3: You can practise safely in our demo sandbox where no real mistakes can happen.\n\n'
          'Important Safety Advice: Take your time. Technology is here to help you, and you can never break your phone by asking questions!\n\n'
          'Would you like to practise this yourself?';
    }
  }
}
