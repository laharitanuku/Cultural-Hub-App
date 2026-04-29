# Cultural Hub — AI-Integrated Digital Knowledge Publishing Platform

> A collaborative platform connecting Authors, Readers, and Publishers through AI-powered personalization and intelligent writing environments.

---

## Repository

- GitHub: [https://github.com/laharitanuku/Cultural-Hub-App.git](https://github.com/laharitanuku/Cultural-Hub-App.git)
- Live Prototype: [Figma Prototype](https://www.figma.com/proto/06YBBLqL3DAcAdfWAqRjNQ/Cultural-Hub?node-id=1-2&p=f&t=IbSWyNnje1eDbsEh-1&scaling=min-zoom&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=1%3A2)

---

## Overview

Cultural Hub is an AI-enhanced collaborative app prototype designed to democratise knowledge publishing in India. It bridges the gap between authors, readers, and publishers by providing a unified platform with intelligent, mood-based writing environments and personalised reading experiences.

This repository contains the Flutter implementation used to demonstrate the Cultural Hub concept in a working environment.

This project is also the foundation of the research paper:

> *"Cultural Hub: An AI-Integrated Digital Knowledge Publishing Framework for Author Empowerment and Knowledge Democratisation towards Viksit Bharat"*
> - **Accepted for Publication, Vidhyayana Journal, Feb 2026**

---

## Key Features

### For Authors

- Upload and publish books or written content directly.
- AI-powered mood-based writing environments that adapt to the author's emotional state.
- Personalised suggestions to enhance writing flow.

### For Readers

- Browse and access a wide range of published content.
- AI-driven personalised recommendations based on reading history and preferences.
- Clean, distraction-free reading interface.

### For Publishers

- Connect with authors directly through in-app communication.
- Discover new talent and manage the publishing pipeline.
- Streamlined collaboration tools for publication workflows.

---

## AI Integration

| Feature | Description |
| --- | --- |
| Mood-based Writing Environment | Detects author mood and adapts UI and suggestions accordingly |
| AI Personalisation | Recommends content to readers based on behaviour |
| Smart Publishing Assistance | Guides authors through the publishing process |

---

## User Roles

```text
Cultural Hub
├── Author      -> Upload content, use AI writing tools
├── Reader      -> Access and discover content
└── Publisher   -> Connect with authors, manage publications
```

---

## Tools Used

| Tool | Purpose |
| --- | --- |
| Figma | UI/UX design and interactive prototype |
| AI Concepts | Mood detection and personalisation logic |

---

## Research Connection

This app prototype served as the practical implementation base for research presented at the Vedant Knowledge Systems National Conference:

- "Reimagining Higher Education in 21st Century: An Inclusive Way Towards Viksit Bharat via NEP 2020 and IKS" - Feb 2026

Journal: Vidhyayana | [vidhyayanaejournal.org](https://vidhyayanaejournal.org/index.php/journal)

---

## Project Context

The current app experience includes:

- An immersive launch experience.
- A focused writing workspace.
- A books discovery and browsing flow.
- An AI-assisted content refinement experience.

---

## Architecture

```text
Cultural Hub
├── lib/main.dart
│   ├── LaunchScreen
│   ├── HomeScreen
│   └── WebIntroScreen
├── lib/screens/
│   ├── writing_screen.dart
│   ├── books_screen.dart
│   ├── book_detail_screen.dart
│   ├── book_reader_screen.dart
│   ├── ai_panel.dart
│   ├── formatting_panel.dart
│   └── workspace_selector.dart
├── lib/services/
│   ├── ai_service.dart -> Groq chat completions API
│   ├── books_service.dart -> Google Books API
│   └── storage_service.dart -> local draft persistence
├── lib/models/
│   ├── draft.dart
│   └── book.dart
└── lib/themes/
	└── workspace_theme.dart
```

- The launch flow routes web users to a book-themed onboarding screen and mobile/desktop users to the main home screen.
- Writing and reading features are separated into dedicated screens to keep navigation clear and maintainable.
- API calls and local persistence are isolated in service classes so UI widgets stay focused on presentation.

---

## Tech Stack

- Flutter
- Dart
- `http`
- `shared_preferences`
- `uuid`
- `google_fonts`
- `url_launcher`

---

## Setup

### Prerequisites

- Flutter SDK installed
- Dart SDK included with Flutter
- A connected device, emulator, or browser target

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### Run on Web

```bash
flutter run -d chrome
```

---

## Author

**Tanuku Leela Vani Lahari**

- 3rd Year B.Tech Computer Engineering
- Stanley College of Engineering and Technology for Women, Hyderabad
- Email: lahariwork6@gmail.com

---

## License

This project is for academic and portfolio purposes.

## Configuration Notes

- Provide the Groq API key at build time through `GROQ_API_KEY`.
- Do not commit secrets into the repository.
