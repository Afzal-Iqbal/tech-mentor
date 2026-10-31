# TechSaathi AI - Design System & Accessibility Guide

## 1. Design Philosophy
Elderly and first-time digital users face unique cognitive and physical challenges:
1. **Presbyopia & reduced contrast sensitivity**: Requires high-contrast palette and large, clean fonts.
2. **Motor precision reduction / tremor**: Requires large touch targets (minimum 56x56 pt) with generous padding.
3. **Cognitive overload**: Requires single-task screens, no clutter, and explicit text labels for all icons.
4. **Anxiety of breaking something**: Requires friendly tones, clear cancel/back paths, and safe simulation indicators.

---

## 2. Color Palette

```
Primary Background:   #F8FAF9  (Canvas)
Secondary Background: #FFFFFF  (Cards & Modals)
Primary Brand Color:  #168C83  (Deep Teal - high contrast)
Secondary Teal:       #DDF3EF  (Subtle Accent)
Primary Text:         #24332F  (High-contrast Slate)
Secondary Text:       #687873  (Muted Slate)
Border:               #E6ECE9  (Subtle Border)
Success:              #238B61  (Confirmation / Safe)
Warning:              #E5A23B  (Caution)
Danger:               #D9534F  (High Risk / Scam)
```

---

## 3. Typography Hierarchy

Using **Google Fonts Noto Sans** (English / Roman Urdu) and **Noto Nastaliq Urdu** (Urdu RTL):

| Style | Font Size | Weight | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Heading Large** | 28-30 pt | Bold | 1.3 | Main screen titles & welcomes |
| **Heading Medium** | 22-24 pt | SemiBold | 1.3 | Section headers & card titles |
| **Card Heading** | 18-20 pt | SemiBold | 1.3 | Action cards |
| **Body Large** | 18-19 pt | Regular | 1.5 | Primary explanation paragraphs |
| **Body Medium** | 16-17 pt | Regular | 1.4 | Supporting descriptions |
| **Button Label** | 18-19 pt | SemiBold | 1.2 | High-contrast action buttons |

---

## 4. UI Components

### Buttons
- **Touch Target**: Minimum `56 x 56 pt`.
- **Corner Radius**: `16 pt`.
- **Elevation**: Flat with subtle border or minimal elevation (`2 pt`).
- **Icons**: Never use an icon alone without a descriptive text label.

### Cards
- **Background**: `#FFFFFF`.
- **Border**: `1 pt` solid `#E6ECE9`.
- **Border Radius**: `16 pt`.
- **Padding**: Minimum `16 pt` internal padding.

### Language & RTL Handling
- The app supports **Urdu (اردو)** with proper Right-to-Left (RTL) directional text, proper mirrored icons, and correct Urdu Nastaliq font metrics.
- English and Roman Urdu use Left-to-Right (LTR) layout.
