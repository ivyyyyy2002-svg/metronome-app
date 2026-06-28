# MetriLoop

A Flutter-based melodic metronome app designed to support music practice with both rhythmic clicks and configurable musical note patterns. This project was developed as a Western University ECE software project and focuses on mobile app development, audio playback, UI interaction, and configurable practice settings.

## Overview

Traditional metronomes usually provide only a simple click sound. This project explores a more musical version of a metronome by combining beat timing with note playback. The app is designed to help users practise with a repeated melodic pattern while also keeping a steady tempo.

The project uses Flutter for cross-platform app development and organizes the application logic, assets, configuration files, and platform-specific files in a standard Flutter project structure.

## Features

- Adjustable metronome tempo
- Rhythmic click playback
- Musical note playback
- Configurable scale and note pattern settings
- Mobile-friendly user interface
- Asset-based audio support
- Separate configuration files for musical settings
- Flutter project structure with iOS and web support

## Technologies Used

- Dart
- Flutter
- Flutter asset management
- Audio playback packages
- JSON configuration
- iOS project configuration
- Web build support
- Git and GitHub

## Project Structure

```text
metronome-app/
├── assets/
│   └── config/        # Configuration files for scale and note pattern settings
├── ios/               # iOS-specific Flutter project files
├── lib/               # Main Flutter/Dart application code
├── test/              # Flutter test files
├── web/               # Web-specific Flutter project files
├── pubspec.yaml       # Flutter dependencies and asset configuration
├── analysis_options.yaml
└── README.md
