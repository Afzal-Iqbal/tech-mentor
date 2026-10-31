# TechSaathi AI - Development Roadmap & Milestone Tracker

## Phase Status Summary

| Phase | Milestone | Priority | Status |
| :--- | :--- | :--- | :--- |
| **Phase 0** | Repo Setup, Architecture & Community Guidelines | P0 | ✅ Completed |
| **Phase 1** | Design System, Accessible Theme & 5-Step Onboarding | P0 | ⏳ Ready |
| **Phase 2** | Home Dashboard & 4-Tab GoRouter Navigation | P0 | ⏳ Ready |
| **Phase 3** | AI Teacher Module (Gemini + Voice STT/TTS) | P0 | ⏳ Ready |
| **Phase 4** | Banking Saathi Curriculum (14 Lessons + Quizzes) | P1 | ⏳ Ready |
| **Phase 5** | Banking Practice Lab (TechSaathi Demo Bank Simulator) | P0 | ⏳ Ready |
| **Phase 6** | Explain My Screen (Vision AI Screenshot Explainer) | P1 | ⏳ Ready |
| **Phase 7** | ScamShield (SMS/WhatsApp Scam Detection) | P1 | ⏳ Ready |
| **Phase 8** | Learning Progress, Independence Tracking & Badges | P2 | ⏳ Ready |
| **Phase 9** | Firebase Auth & Firestore Persistence Layer | P2 | ⏳ Ready |
| **Phase 10** | Testing, Screen Reader Audit & Hackathon Demo Polish | P0 | ⏳ Ready |

---

## Detailed Task Breakdown

### Phase 1: Design System & Onboarding
- [ ] Define `AppColors`, `AppTextStyles`, and `AppTheme`.
- [ ] Implement onboarding state provider.
- [ ] Build 5 onboarding screens with smooth transitions and persistent state.

### Phase 2: Navigation & Home Dashboard
- [ ] Configure `GoRouter` shell navigation with 4 bottom tabs.
- [ ] Implement clean Top Bar with greeting and profile avatar.
- [ ] Build hero card with large voice / text buttons.
- [ ] Add 4 core module cards with accessibility semantics.

### Phase 3: AI Teacher
- [ ] Configure Gemini AI client service.
- [ ] Integrate `speech_to_text` and `flutter_tts` services.
- [ ] Build chat interface with suggested quick prompts.
- [ ] Test Urdu and English voice recognition.

### Phase 4 & 5: Banking Saathi & Practice Lab
- [ ] Create static lesson data structure for all 14 categories.
- [ ] Build interactive lesson viewer with quiz validation.
- [ ] Implement fictional Demo Bank with PKR 50,000 starting balance.
- [ ] Build transfer flow with field-level explainer cards.

### Phase 6 & 7: Explain My Screen & ScamShield
- [ ] Add image picker for screenshot analysis.
- [ ] Add sensitive info disclosure modal.
- [ ] Implement Gemini multimodal image prompt pipeline.
- [ ] Implement ScamShield heuristic regex rules + Gemini deep analysis.

### Phase 8 & 9: Progress & Backend
- [ ] Implement independence rating calculation.
- [ ] Build badge unlock system.
- [ ] Add Firebase Auth (anonymous and email) and Firestore sync.

### Phase 10: Verification
- [ ] Run `flutter analyze`.
- [ ] Run unit and widget tests.
- [ ] Test on Android physical device.
