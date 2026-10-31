# TechSaathi AI (Tech Mentor)

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Supported-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Google Gemini](https://img.shields.io/badge/Google%20Gemini-Multimodal%20AI-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-238B61?style=for-the-badge)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-168C83?style=for-the-badge)](CONTRIBUTING.md)

**Technology Made Simple. Independence Made Possible.**

*AI-powered digital literacy and banking education mobile application designed for parents, grandparents, and first-time smartphone users.*

</div>

---

## 📖 Executive Summary & Product Vision

Many older adults and first-time smartphone users struggle with essential digital tasks because applications are cluttered and technical jargon is overwhelming. Often, they become dependent on younger family members for everyday actions—making video calls, paying utility bills, or transferring funds—leaving them vulnerable to online scams and fraud.

**TechSaathi AI** is a personal digital and banking teacher built from the ground up for people who did not grow up with modern technology.

> **Core Product Principle:**  
> *"Never simply do everything for the user. Teach them how to do it themselves."*

---

## 🎯 Target Audience

- **Parents & Grandparents** navigating smartphones for communication.
- **Older adults** who experience anxiety or fear around making mistakes on mobile apps.
- **First-time digital banking users** learning to pay utility bills, navigate IBANs, and transfer funds safely.
- **Individuals susceptible to financial fraud**, SMS scams, fake prize links, and WhatsApp impersonation.

---

## 🌟 Core Modules

### 1. 🤖 AI Teacher
- **Interactive Multi-modal Assistance**: Powered by Google Gemini through Firebase AI Logic.
- **Multilingual Support**: High-fidelity conversations in **Urdu (اردو)**, **English**, and **Roman Urdu**.
- **Voice-First Design**: Speech-to-text (`speech_to_text`) microphone input and clear spoken responses (`flutter_tts`).
- **Pedagogical Guardrails**:
  - Explains concepts step-by-step with real-life analogies.
  - Never uses unexplained technical jargon.
  - Encourages self-practice: *"Would you like to practise this yourself?"*

### 2. 🏦 Banking Saathi
- **Comprehensive Beginner Curriculum**: 14 bite-sized lesson modules covering:
  1. Mobile Banking Fundamentals
  2. Bank Accounts & Types
  3. Checking Account Balance
  4. Understanding IBAN & Account Numbers
  5. Adding & Managing Beneficiaries
  6. Money Transfer Workflows
  7. Reading Transaction History & Statements
  8. Paying Electricity Bills
  9. Paying Gas Bills
  10. Understanding Debit & ATM Cards
  11. JazzCash Essentials
  12. Easypaisa Essentials
  13. Digital Banking Security
  14. Recognizing Banking Scams
- **Zero-Jargon Explanations**: Concepts explained in relatable terms (e.g., *"A beneficiary is the person who receives the money you send, like your brother or daughter"*).
- **Interactive Quizzes**: Reinforce key learnings after each micro-lesson.

### 3. 🧪 Banking Practice Lab (TechSaathi Demo Bank)
- **100% Fictional Simulation Environment**: Risk-free sandbox mimicking real Pakistani and regional banking flows.
- **Simulated Accounts**: Fictional starting balance of **PKR 50,000**.
- **Guided Workflows**: Interactive beneficiary entry, amount validation, review verification, and mock confirmation receipts.
- **Persistent Warning**: Clear banner: `SIMULATION ONLY - NO REAL MONEY`.
- **Absolute Privacy**: Never connects to real bank APIs and never collects ATM PINs, OTPs, CVVs, or card credentials.

### 4. 🔍 Explain My Screen
- **Screenshot Understanding**: Upload or select a screenshot of confusing app screens.
- **Multimodal AI Decomposition**: Identifies what the screen is, what buttons do, what to watch out for, and the safest next step.
- **Privacy First**: Displays a reminder to mask OTPs, PINs, and account numbers prior to analysis; images are processed ephemerally.

### 5. 🛡️ ScamShield
- **Threat & Scam Scanner**: Paste suspicious SMS text, WhatsApp forwards, or links.
- **Risk Assessment Levels**: Categorized into *Low Indicators*, *Suspicious*, and *High Risk*.
- **Detection Patterns**: Detects urgency tactics, fake lottery claims (e.g., BISP scams, fake lottery wins), impersonation, and fraudulent OTP/password requests.
- **Safety Rule**: Never marks any message as guaranteed 100% safe; directs users to verified official hotlines.

### 6. 📈 Learning & My Progress
- **Independence Metric**: Tracks tasks completed independently without guided hints.
- **Achievement Badges**: Celebrates real milestones (e.g., "Mastered Video Calling", "First Simulated Bill Payment").
- **Minimalist Dashboard**: Clean streak and completion counters without confusing analytical charts.

---

## 🎨 UI/UX Design System & Accessibility

Designed strictly according to the **TechSaathi Beginner Accessibility Standards**:

| Token | Hex Code | Purpose |
| :--- | :--- | :--- |
| **Primary Background** | `#F8FAF9` | Calm, ultra-light soft canvas |
| **Secondary Background** | `#FFFFFF` | Card surfaces & dialogs |
| **Primary Brand** | `#168C83` | Deep supportive teal (high contrast) |
| **Secondary Teal** | `#DDF3EF` | Soft teal accents and highlights |
| **Primary Text** | `#24332F` | High-contrast dark slate |
| **Secondary Text** | `#687873` | Accessible muted slate |
| **Borders & Dividers** | `#E6ECE9` | Subtle structural division |
| **Success** | `#238B61` | Confirmatory and safe actions |
| **Warning** | `#E5A23B` | Cautions & alerts |
| **Danger** | `#D9534F` | High risk indicators |

### Accessibility Rules
- **Light Mode Default**: Eliminates glare and high visual fatigue for aging eyes.
- **Touch Targets**: Minimum **56x56 pt** on all interactive elements.
- **Typography**: `Noto Sans` for English / Roman Urdu, and `Noto Nastaliq Urdu` with full RTL layout support.
- **No Mystery Meat Navigation**: Every single icon is paired with clear descriptive text.

---

## 🏗️ Project Architecture

Organized using a clean, feature-driven architecture powered by **Riverpod** and **GoRouter**:

```
lib/
├── main.dart                       # Application entry point
├── app/
│   ├── app.dart                    # Root MaterialApp widget & Riverpod scope
│   ├── router.dart                 # Declarative GoRouter configuration
│   └── theme/
│       ├── app_colors.dart         # Design system color constants
│       ├── app_text_styles.dart    # Accessible typography scales
│       └── app_theme.dart          # Light mode ThemeData definitions
├── core/
│   ├── constants/                  # App constants & strings
│   ├── services/                   # AI, TTS, STT & Storage interfaces
│   ├── utils/                      # RTL helpers, formatters & validators
│   └── widgets/                    # Reusable buttons, cards, app bar
├── data/
│   ├── models/                     # Shared domain models
│   └── repositories/               # Firestore & local storage repositories
└── features/
    ├── onboarding/                 # 5-step welcoming onboarding flow
    ├── home/                       # Simplified 4-card dashboard
    ├── ai_teacher/                 # Multilingual Gemini chat with voice
    ├── banking/                    # 14 Banking Saathi lessons & quizzes
    ├── practice_lab/               # TechSaathi Demo Bank simulator
    ├── screen_explainer/           # Multimodal screenshot explainer
    ├── scamshield/                 # SMS/WhatsApp fraud detector
    ├── learning/                   # Category-based lesson browser
    ├── progress/                   # Achievement & independence tracking
    └── profile/                    # Settings, language & accessibility prefs
```

---

## 🛠️ Technology Stack

| Layer | Technology |
| :--- | :--- |
| **Framework** | [Flutter 3.x](https://flutter.dev) (Mobile Android target) |
| **Language** | [Dart 3.x](https://dart.dev) |
| **State Management** | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) |
| **Navigation** | [go_router](https://pub.dev/packages/go_router) |
| **AI Engine** | [Google Gemini API](https://pub.dev/packages/google_generative_ai) / Firebase AI Logic |
| **Backend & Auth** | [Firebase Core](https://pub.dev/packages/firebase_core), [Auth](https://pub.dev/packages/firebase_auth), [Firestore](https://pub.dev/packages/cloud_firestore) |
| **Voice & Speech** | [speech_to_text](https://pub.dev/packages/speech_to_text), [flutter_tts](https://pub.dev/packages/flutter_tts) |
| **Typography** | [google_fonts](https://pub.dev/packages/google_fonts) (Noto Sans / Noto Nastaliq Urdu) |
| **Local Cache** | [shared_preferences](https://pub.dev/packages/shared_preferences) |

---

## 🗺️ Development Roadmap

- [x] **Phase 0: Repository & Architecture Foundation**
  - Git repository initialization and collaborator access.
  - Comprehensive documentation, design system tokens, CI/CD pipeline, and directory skeleton.
- [ ] **Phase 1: Design System & Onboarding**
  - Theme implementation, accessible typography, 5-screen onboarding, and language switcher.
- [ ] **Phase 2: Home Dashboard & Navigation**
  - 4-tab GoRouter bottom navigation, primary voice/text input card, 4 core cards, continue learning.
- [ ] **Phase 3: AI Teacher Module**
  - Gemini API client, speech-to-text input, flutter_tts speech response, suggested questions, Urdu/English prompts.
- [ ] **Phase 4: Banking Saathi Curriculum**
  - 14 interactive lessons, visual diagrams, safety warnings, and post-lesson quizzes.
- [ ] **Phase 5: Banking Practice Lab**
  - TechSaathi Demo Bank simulator, PKR 50,000 fictional balance, money transfer and bill payment sandbox.
- [ ] **Phase 6: Explain My Screen**
  - Image picker, Gemini multimodal vision analysis, sensitive info warning, actionable step breakdown.
- [ ] **Phase 7: ScamShield**
  - Text input scanner, heuristic and AI scam detection, risk level assessment, official reporting links.
- [ ] **Phase 8: Learning Progress & Badges**
  - Independence tracking logic, streak counter, badge unlocks, clean visual metrics.
- [ ] **Phase 9: Firebase Integration & Persistence**
  - Anonymous/email auth, Firestore progress sync, local offline-first fallback.
- [ ] **Phase 10: Testing, Accessibility Polish & Hackathon Demo**
  - Device verification, unit tests, screen reader accessibility audit, release bundle.

---

## 🔒 Security & Privacy Guarantees

1. **Zero Financial Access**: TechSaathi is an educational platform. It does not integrate with open banking APIs, does not initiate real transfers, and does not hold funds.
2. **Zero Sensitive Credential Collection**: Under no circumstances will TechSaathi request, prompt for, or persist ATM PINs, OTP codes, card CVVs, or online banking passwords.
3. **Ephemeral Image Processing**: Screenshots submitted to the "Explain My Screen" module are analyzed ephemerally and never permanently stored on public cloud servers.
4. **Independent Verification First**: ScamShield provides educational risk evaluations and explicitly directs users to contact official banking institutions directly.

---

## 👥 Contributors & Core Team

- **Syed Muhammad Hunain** ([@SyedMuhammadHunain](https://github.com/SyedMuhammadHunain)) - Project Lead
- **Afzal Iqbal** ([@Afzal-Iqbal](https://github.com/Afzal-Iqbal)) - Collaborator
- **Makshoof** ([@makshoof](https://github.com/makshoof)) - Collaborator

---

## 📄 License

This project is licensed under the terms of the [MIT License](LICENSE).
