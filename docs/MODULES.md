# TechSaathi AI - Feature Modules Specification

## 1. Onboarding Module
- **Screen 1**: Welcome message and friendly illustration.
- **Screen 2**: Language selector (`اردو`, `English`, `Roman Urdu`).
- **Screen 3**: Experience level (`Completely new`, `I know a little`, `Basic applications`).
- **Screen 4**: Learning style preference (`Step-by-step text`, `Voice explanations`, `Both voice and text`).
- **Screen 5**: Completion & transition into the Home dashboard.

---

## 2. Home Dashboard
- **Top Bar**: Minimal logo, personalized Assalam-o-Alaikum greeting, user name, profile icon.
- **Hero Card**: "How can I help you today?" with prominent Voice (Microphone) and Text input buttons.
- **4 Primary Action Cards**:
  1. **AI Teacher**: Ask anything about technology.
  2. **Banking Saathi**: Learn to use banking applications safely.
  3. **ScamShield**: Learn to recognize online scams.
  4. **Explain My Screen**: Understand confusing phone screens.
- **Secondary Widgets**: Continue Learning snippet and a simplified Progress summary.

---

## 3. AI Teacher Module
- **Gemini Engine**: System prompt tuned to patient, encouraging tone for elderly learners.
- **Voice Pipeline**:
  - `speech_to_text`: Transcribes spoken voice in Urdu/English.
  - `flutter_tts`: Reads responses aloud with pause/repeat controls.
- **Suggested Queries**:
  - "How do I make a WhatsApp video call?"
  - "How do I mute during a call?"
  - "How do I identify a fake link?"
  - "How do I check my account balance?"

---

## 4. Banking Saathi Curriculum
14 Beginner-friendly lessons:
1. Mobile Banking Fundamentals
2. Bank Accounts Explained
3. Checking Your Account Balance
4. Understanding IBAN & Account Numbers
5. Beneficiaries (Who they are and how to add them)
6. Step-by-Step Money Transfers
7. Transaction History & Reading Receipts
8. Electricity Bill Payments
9. Gas Bill Payments
10. Debit & ATM Cards
11. JazzCash Essentials
12. Easypaisa Essentials
13. Mobile Banking Security Rules
14. Spotting Banking Impersonators & Scams

---

## 5. Banking Practice Lab (TechSaathi Demo Bank)
- Persistent banner: `SIMULATION ONLY - NO REAL MONEY`.
- Starting virtual balance: **PKR 50,000**.
- Fictional transfer process:
  1. Recipient Beneficiary Name
  2. Account / IBAN input
  3. Amount input
  4. Review & confirmation
  5. Success receipt generation
- Beginner tutorial hints beside each field explaining what the field means.

---

## 6. Explain My Screen
- Image selection from gallery.
- Privacy check modal: Reminder to hide passwords, OTPs, and card numbers.
- Structured AI response:
  1. What is this screen?
  2. What do the important buttons mean?
  3. What can you do here?
  4. What should you be careful about?
  5. What is the next safe step?

---

## 7. ScamShield
- Text analyzer for SMS and WhatsApp messages.
- Heuristic + Gemini threat detection.
- Categorization: Low Indicators, Suspicious, High Risk.
- Explicit warnings: Reminds users to contact official helplines and never share OTPs.

---

## 8. Progress & Independence Tracking
- Measures user ability to complete simulated exercises without tapping hint/help buttons.
- Achievement badges earned through hands-on practice.
