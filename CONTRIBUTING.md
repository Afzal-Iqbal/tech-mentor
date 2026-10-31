# Contributing to TechSaathi AI

Thank you for your interest in contributing to **TechSaathi AI**! Our mission is to make technology accessible, friendly, and empowering for older adults and digital beginners.

## Code of Conduct
Please review and adhere to our [Code of Conduct](CODE_OF_CONDUCT.md) in all community interactions.

## How to Contribute

### 1. Branching Strategy
- `main`: Production-ready, stable code.
- `develop`: Integration branch for active feature development.
- Feature branches: `feat/<feature-name>`, `fix/<bug-name>`, `docs/<doc-name>`.

### 2. Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/SyedMuhammadHunain/tech-mentor.git
   cd tech-mentor
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run analyzer:
   ```bash
   flutter analyze
   ```
4. Run tests:
   ```bash
   flutter test
   ```

### 3. Core Principles to Remember
- **Simplicity First**: Never add clutter or unnecessary UI elements.
- **Accessibility Non-Negotiable**: Minimum touch target of 56x56, high contrast, readable text sizes.
- **Teach, Don't Do**: Every feature must help the user learn independence.
- **Security & Privacy**: Never collect or persist actual banking passwords, OTPs, or PINs.

### 4. Submitting a Pull Request
- Ensure all tests pass and `flutter analyze` has zero warnings.
- Complete the PR checklist in the PR template.
- Request review from core maintainers: `@SyedMuhammadHunain`, `@Afzal-Iqbal`, or `@makshoof`.
