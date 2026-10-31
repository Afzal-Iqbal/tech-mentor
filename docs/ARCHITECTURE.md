# TechSaathi AI - Architecture & Technical Specification

## 1. System Overview
TechSaathi AI is built on a modular, feature-first architecture optimized for performance, accessibility, offline resilience, and ease of demonstration.

```
                           +--------------------------+
                           |     TechSaathi App       |
                           |  (Flutter / Android)     |
                           +------------+-------------+
                                        |
       +--------------------------------+--------------------------------+
       |                                |                                |
+------v------+                  +------v------+                  +------v------+
| UI / Theme  |                  | Riverpod    |                  |  GoRouter   |
| (Accessible)|                  | State Mgmt  |                  | Declarative |
+------+------+                  +------+------+                  +------+------+
       |                                |                                |
       +--------------------------------+--------------------------------+
                                        |
                 +----------------------+----------------------+
                 |                                             |
        +--------v-------+                            +--------v-------+
        | Local Services |                            | Remote Services|
        | - TTS          |                            | - Firebase Auth|
        | - STT          |                            | - Firestore    |
        | - SharedPrefs  |                            | - Gemini AI    |
        +----------------+                            +----------------+
```

## 2. Directory Structure
```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       └── app_theme.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── asset_constants.dart
│   ├── services/
│   │   ├── ai_service.dart
│   │   ├── speech_service.dart
│   │   └── tts_service.dart
│   ├── utils/
│   │   ├── text_direction_helper.dart
│   │   └── validation_helper.dart
│   └── widgets/
│       ├── accessible_button.dart
│       ├── accessible_card.dart
│       ├── accessible_app_bar.dart
│       └── simulation_banner.dart
├── data/
│   ├── models/
│   │   ├── user_profile.dart
│   │   ├── lesson.dart
│   │   ├── transaction_model.dart
│   │   └── scam_analysis_result.dart
│   └── repositories/
│       ├── user_repository.dart
│       ├── banking_repository.dart
│       └── progress_repository.dart
└── features/
    ├── onboarding/
    ├── home/
    ├── ai_teacher/
    ├── banking/
    ├── practice_lab/
    ├── screen_explainer/
    ├── scamshield/
    ├── learning/
    ├── progress/
    └── profile/
```

## 3. State Management (Riverpod)
We use `flutter_riverpod` with immutable state objects:
- `userProfileProvider`: Holds the current user, selected language, accessibility scale, and learning stats.
- `aiTeacherChatProvider`: Manages conversation history, Gemini streaming state, and speech status.
- `demoBankProvider`: Manages fictional account balance (PKR 50,000), beneficiary list, and transaction history.
- `scamShieldProvider`: Analyzes message text and maintains recent threat assessment results.
- `screenExplainerProvider`: Handles screenshot upload state, image preprocessing, and multimodal responses.

## 4. Routing (GoRouter)
Four primary bottom navigation tabs:
1. `/home` - Main dashboard with quick voice/text action & primary module cards.
2. `/learn` - Category-based lesson browser (Smartphone, WhatsApp, Banking, Security).
3. `/practice` - Interactive simulators (TechSaathi Demo Bank).
4. `/progress` - Learning streaks, completed tasks, and independence badges.

Additional sub-routes:
- `/onboarding` - 5-screen initial onboarding flow.
- `/ai-teacher` - Full-screen AI voice/text tutor.
- `/banking/lesson/:id` - Detailed lesson with quiz.
- `/banking/practice` - Demo Bank transfer simulation flow.
- `/scamshield` - Fraud message scanner.
- `/screen-explainer` - Multimodal screenshot assistant.
- `/profile` - User settings, language preference, and voice toggles.

## 5. Offline Fallback & Reliability
Every remote feature has a local fallback mode:
- If Gemini API is unreachable or network is offline, the AI Teacher and ScamShield fall back to pre-indexed, curated educational heuristics and sample explanations.
- If Firebase is unavailable, progress and simulation state persist locally using `shared_preferences`.
