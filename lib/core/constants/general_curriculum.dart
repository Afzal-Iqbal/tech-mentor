import 'package:flutter/material.dart';
import '../../data/models/learning_lesson.dart';

/// Complete General Digital Literacy Curriculum.
class GeneralCurriculum {
  GeneralCurriculum._();

  static final List<LearningCategory> categories = [
    const LearningCategory(
      id: 'cat_smartphone_basics',
      name: 'Smartphone Basics',
      nameUrdu: 'اسمارٹ فون کے بنیادی اصول',
      nameRomanUrdu: 'Smartphone Basics',
      description: 'Master the touchscreen, volume buttons, charging, and silent mode.',
      descriptionUrdu: 'ٹچ اسکرین، آواز تیز آہستہ کرنا، اور چارجنگ کے آسان طریقے سیکھیں۔',
      icon: Icons.smartphone,
      lessons: [
        GeneralLesson(
          id: 'sp_1_touch',
          categoryId: 'cat_smartphone_basics',
          title: 'How to Touch & Scroll Gently',
          titleUrdu: 'ٹچ اسکرین کو نرمی سے استعمال کرنا',
          explanation: 'Smartphones need only a gentle tap with your fingertip. Never press hard with your fingernail.',
          explanationUrdu: 'فون کی سکرین پر صرف انگلی کے سرے سے ہلکا سا چھونا کافی ہوتا ہے، ناخن سے زور لگانے کی ضرورت نہیں۔',
          steps: [
            'Tap once to open an application.',
            'Swipe your finger upward gently to read down the page.',
            'Tap the back arrow at the bottom to return to the previous screen.',
          ],
          stepsUrdu: [
            'کوئی بھی ایپ کھولنے کے لیے انگلی سے ایک بار چھوئیں۔',
            'نیچے کا صفحہ پڑھنے کے لیے انگلی کو نرمی سے اوپر کی طرف سلائیڈ کریں۔',
            'پچھلی سکرین پر واپس جانے کے لیے نیچے تیر کا نشان دبائیں۔',
          ],
          safetyTip: 'Keep your hands clean and dry before touching your phone screen.',
          safetyTipUrdu: 'فون استعمال کرنے سے پہلے ہاتھ صاف اور خشک رکھیں۔',
          quizQuestion: 'How much pressure does a phone screen need to respond?',
          quizQuestionUrdu: 'فون کی سکرین دبانے کے لیے کتنا زور لگانا چاہیے؟',
          quizOptions: [
            'A very gentle tap with the soft tip of your finger',
            'Pressing as hard as possible with a pen',
            'Tapping repeatedly with both thumbs together',
          ],
          quizOptionsUrdu: [
            'انگلی کے سرے سے نہایت ہلکا سا چھونا',
            'قلم سے زور لگا کر دبانا',
            'دونوں انگوٹھوں سے ایک ساتھ زور سے دبانا',
          ],
          correctIndex: 0,
        ),
        GeneralLesson(
          id: 'sp_2_volume',
          categoryId: 'cat_smartphone_basics',
          title: 'Controlling Volume & Silent Mode',
          titleUrdu: 'آواز کو کم زیادہ اور سائلنٹ کرنا',
          explanation: 'Learn how to adjust the ringtone volume and put the phone on silent during prayers or rest.',
          explanationUrdu: 'نماز کے اوقات یا آرام کے وقت فون کو سائلنٹ (خاموش) کرنے کا طریقہ۔',
          steps: [
            'Press the long button on the side of your phone: top part increases sound, bottom part lowers it.',
            'Swipe down from the very top of your screen to find the bell or speaker icon.',
            'Tap the bell icon until it shows a line across it (Silent mode).',
          ],
          stepsUrdu: [
            'موبائل کے سائیڈ پر لگے بٹن کا اوپری حصہ آواز بڑھاتا ہے اور نچلا حصہ کم کرتا ہے۔',
            'سکرین کے اوپر سے نیچے انگلی پھیریں اور گھنٹی کے نشان پر ٹیپ کریں۔',
            'گھنٹی پر لکیر آنے کا مطلب ہے فون سائلنٹ ہو گیا ہے۔',
          ],
          safetyTip: 'Remember to turn the sound back on after prayers so you do not miss family calls.',
          safetyTipUrdu: 'نماز کے بعد گھنٹی دوبارہ آن کر لیں تاکہ بچوں کی ضروری کال مس نہ ہو۔',
          quizQuestion: 'How can you quickly silence your phone when entering a quiet room?',
          quizQuestionUrdu: 'کسی خاموش جگہ جاتے وقت فون کو فوراً سائلنٹ کیسے کریں؟',
          quizOptions: [
            'Press the lower volume button or tap the Bell icon in quick settings',
            'Throw the phone inside a pillow',
            'Remove the SIM card',
          ],
          quizOptionsUrdu: [
            'آواز کا نچلا بٹن دبائیں یا سکرین پر گھنٹی کا نشان دبائیں',
            'فون کو تکیے میں چھپا دیں',
            'سم کارڈ باہر نکال لیں',
          ],
          correctIndex: 0,
        ),
      ],
    ),

    const LearningCategory(
      id: 'cat_whatsapp',
      name: 'WhatsApp',
      nameUrdu: 'واٹس ایپ کا استعمال',
      nameRomanUrdu: 'WhatsApp Guide',
      description: 'Send voice notes, photos, and messages to your children and grandchildren.',
      descriptionUrdu: 'بچوں اور پیاروں کو وائس میسج اور تصویریں بھیجنے کا آسان طریقہ۔',
      icon: Icons.chat,
      lessons: [
        GeneralLesson(
          id: 'wa_1_voice_note',
          categoryId: 'cat_whatsapp',
          title: 'Sending a Voice Note Without Typing',
          titleUrdu: 'بغیر ٹائپ کیے وائس میسج بھیجنا',
          explanation: 'You do not need to type English or Urdu letters. Just speak into the microphone!',
          explanationUrdu: 'آپ کو کی بورڈ پر لکھنے کی ضرورت نہیں، صرف مائیک دبا کر اپنی آواز میں بات کریں۔',
          steps: [
            'Open the chat with your family member.',
            'Press and HOLD the small green microphone icon at the bottom right.',
            'Speak clearly into the phone.',
            'Lift your finger to send the message immediately.',
          ],
          stepsUrdu: [
            'جس عزیز سے بات کرنی ہو ان کا نام کھولیں۔',
            'نیچے کونے میں مائیکروفون کا نشان دبا کر رکھیں۔',
            'اپنی بات کہیں اور انگلی اٹھا لیں، میسج چلا جائے گا۔',
          ],
          safetyTip: 'If you make a mistake while talking, slide your finger left towards the trash bin to cancel.',
          safetyTipUrdu: 'اگر بات کرتے وقت کوئی غلطی ہو جائے تو انگلی بائیں طرف پھیر دیں، میسج کینسل ہو جائے گا۔',
          quizQuestion: 'If you want to cancel a voice note before sending, what should you do?',
          quizQuestionUrdu: 'اگر وائس میسج بولتے وقت کینسل کرنا ہو تو کیا کریں؟',
          quizOptions: [
            'Slide your finger to the left towards the dustbin icon',
            'Drop the phone on the bed',
            'Press the screen with both hands',
          ],
          quizOptionsUrdu: [
            'انگلی کو بائیں طرف کوڑے دان کے نشان کی طرف سرکا دیں',
            'فون کو بیڈ پر پھینک دیں',
            'دونوں ہاتھوں سے سکرین دبائیں',
          ],
          correctIndex: 0,
        ),
      ],
    ),

    const LearningCategory(
      id: 'cat_video_calling',
      name: 'Video Calling',
      nameUrdu: 'ویڈیو کالنگ',
      nameRomanUrdu: 'Video Calling',
      description: 'See the smiling faces of your grandchildren living far away.',
      descriptionUrdu: 'دور رہنے والے بچوں اور پوتوں نواسوں کو ویڈیو پر دیکھنے کا طریقہ۔',
      icon: Icons.videocam,
      lessons: [
        GeneralLesson(
          id: 'vc_1_make_call',
          categoryId: 'cat_video_calling',
          title: 'Starting a WhatsApp Video Call',
          titleUrdu: 'واٹس ایپ ویڈیو کال ملانا',
          explanation: 'With one tap on the camera icon, you can see and hear your family anywhere in the world.',
          explanationUrdu: 'کیمرے کے نشان کو چھونے سے آپ دور بیٹھے اپنے بچوں کو سامنے دیکھ سکتے ہیں۔',
          steps: [
            'Open your WhatsApp contact.',
            'Look at the top-right corner for the small Video Camera icon.',
            'Tap it once and hold the phone in front of your face at eye level.',
            'When finished, tap the red telephone button to end the call.',
          ],
          stepsUrdu: [
            'اپنے بچے کا چیٹ پیج کھولیں۔',
            'اوپر دائیں کونے میں ویڈیو کیمرے کا نشان دبائیں۔',
            'فون کو اپنے چہرے کے سامنے رکھیں اور بات کریں۔',
            'بات ختم ہونے پر لال فون کا بٹن دبا کر کال کاٹ دیں۔',
          ],
          safetyTip: 'Make sure your room has a light source in front of your face, not behind you.',
          safetyTipUrdu: 'کمرے کی بتی اپنے چہرے کے سامنے رکھیں تاکہ آپ کا چہرہ صاف نظر آئے۔',
          quizQuestion: 'What button ends a video call when you are finished talking?',
          quizQuestionUrdu: 'ویڈیو کال ختم کرنے کے لیے کون سا بٹن دبایا جاتا ہے؟',
          quizOptions: [
            'The Red telephone button',
            'The Green camera button',
            'The volume up button',
          ],
          quizOptionsUrdu: [
            'لال رنگ کا فون والا بٹن',
            'سبز رنگ کا کیمرہ بٹن',
            'آواز تیز کرنے والا بٹن',
          ],
          correctIndex: 0,
        ),
      ],
    ),

    const LearningCategory(
      id: 'cat_cybersecurity',
      name: 'Cybersecurity & Scams',
      nameUrdu: 'انٹرنیٹ فراڈ اور سائبر سیکیورٹی',
      nameRomanUrdu: 'Cybersecurity',
      description: 'Simple rules to stay safe from fake lotteries, OTP theft, and WhatsApp hacks.',
      descriptionUrdu: 'جعلی لاٹریوں، او ٹی پی چوری اور ہیکرز سے محفوظ رہنے کے آسان اصول۔',
      icon: Icons.shield,
      lessons: [
        GeneralLesson(
          id: 'cs_1_otp_rule',
          categoryId: 'cat_cybersecurity',
          title: 'The Golden OTP Rule',
          titleUrdu: 'او ٹی پی کا سنہرا قانون',
          explanation: 'OTP stands for One-Time Password. It is like the master key to your front gate.',
          explanationUrdu: 'او ٹی پی وہ خفیہ کوڈ ہے جو میسج میں آتا ہے، یہ آپ کے گھر کے تالے کی اصل چابی ہے۔',
          steps: [
            'Whenever an SMS with numbers arrives saying "Your code is 123456", keep it private.',
            'Never read or tell this number to ANY caller, no matter what they claim.',
            'If a caller insists, hang up immediately.',
          ],
          stepsUrdu: [
            'جب بھی فون پر میسج میں کوئی کوڈ آئے، اسے صرف اپنے تک رکھیں۔',
            'فون کال پر کوئی بھی شخص یہ کوڈ مانگے تو کبھی نہ بتائیں۔',
            'کوئی ضد کرے تو فوراً فون کاٹ دیں۔',
          ],
          safetyTip: 'Banks will NEVER ask you for your OTP code.',
          safetyTipUrdu: 'بینک کا کوئی ملازم کبھی آپ سے او ٹی پی نہیں مانگتا۔',
          quizQuestion: 'Who is allowed to ask for your SMS OTP code?',
          quizQuestionUrdu: 'فون پر آنے والا او ٹی پی کوڈ کس کو بتانا چاہیے؟',
          quizOptions: [
            'NOBODY! Never tell your OTP code to anyone',
            'Anyone claiming to be an army officer',
            'A lottery manager',
          ],
          quizOptionsUrdu: [
            'کسی کو بھی نہیں! یہ کوڈ ہمیشہ صرف اپنے پاس خفیہ رکھیں',
            'کوئی بھی جو افسر بن کر کال کرے',
            'لاٹری دینے والا',
          ],
          correctIndex: 0,
        ),
      ],
    ),
  ];
}
