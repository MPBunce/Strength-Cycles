# Forge

An iOS training log for lifting cycles, daily bodyweight work, step goals and personal challenges. Built with SwiftUI and SwiftData.

Forge was previously released as **Strength Cycles**. It keeps the same bundle identifier (`mpbunce.Strength-Cycles`) so existing installs update in place and keep their data.

## Features

### Today
The home tab for the current day.

- **Steps**: today's step count from Apple Health, progress toward your daily goal, and the last seven days at a glance. Set the goal in Settings.
- **Daily Work**: bodyweight exercises you do every day, using one of three methods:
  - *Total reps*: hit a number of reps spread across the day.
  - *Ladder*: 1, 2, 3 … up to a peak rung.
  - *Sets*: a fixed number of sets of a fixed number of reps.

  Log reps with the quick-add button or set an exact count. Logs reset each day.
- **Challenges**: one-off goals you tick off when done. Start from presets (Villain Challenge stages, 20-Minute Aerobic Solution, 60s dead hang) or write your own.

### Training
- Start a cycle from a built-in program: 5/3/1, 5/3/1 Boring But Big, nSuns (4, 5 and 6 day), Greyskull LP, Garcia, Menzer, Arnold Split, Push Pull Legs, or Upper Lower (4 and 5 day).
- 5/3/1 and nSuns calculate working weights from your training maxes. The other programs leave weights blank for you to fill in.
- **Custom templates**: build your own program with named days and exercises prescribed as sets × reps, with an optional AMRAP last set. Find them under *My Templates* when adding a cycle; swipe to edit or delete.
- Tick off sets as you go: tap once for done, twice for failed, three times to reset. AMRAP sets open a sheet to log the reps you hit.

### Running
Under Training › Running, separate from strength cycles.

- Plans: Couch to 5K, 5K to 10K and Half Marathon. Interval runs have a guided timer with spoken run/walk cues.
- Log distance and (for distance runs) time after each run; log single runs outside a plan.
- Log race results for 5K, 10K, half and full marathon, with pace and personal bests.

### Progress
- **Charts**: estimated one-rep max over time for squat, bench, deadlift and overhead press, using sets marked done on completed training days.
- **Activity**: a calendar of completed training days.
- **Goals**: strength milestones that tick themselves off from logged sets, and running goals for each race distance, including a fixed top-5% time.
- **Badges**: workouts and step days per year, kilometres run per year, and unbroken streaks for daily work and stretching.

### Settings
- Weight unit (lbs or kg). Each cycle keeps the unit it was created with.
- Training maxes for squat, bench, deadlift and overhead press.
- Daily step goal.
- Equipment: barbell weight and smallest plate, used to round calculated weights.
- Appearance: System, Light or Dark.

A full in-app guide lives under Settings › About › How Forge Works.

## Requirements

- Xcode 16 or later
- iOS 18.4 or later
- HealthKit capability (already configured in `Forge.entitlements`). Step tracking needs a device or simulator with the Health app.

## Getting started

1. Open `Forge.xcodeproj` in Xcode.
2. Select the **Forge** scheme and an iPhone simulator or device.
3. Build and run (⌘R).

To run on your own device, set your development team under *Signing & Capabilities*.

## Project structure

```
Forge/
├── ForgeApp.swift          App entry point and SwiftData container
├── ContentView.swift       Tab bar: Today, Training, Progress, Settings
├── Models/
│   ├── Cycles/             Cycles, training days, exercises, sets, custom templates
│   ├── ProgramTemplates/   Built-in programs and default set schemes
│   ├── Progress/           Strength goals
│   ├── Settings/           User settings and unit conversion
│   └── Today/              Daily work, challenges, Apple Health step counter
└── Views/
    ├── TodayViews/
    ├── CyclesViews/        Includes the custom template editor
    ├── ProgressViews/
    └── SettingsViews/
```

## Data and privacy

All training data is stored on device with SwiftData. Step counts are read from Apple Health with your permission and are never written back or sent anywhere.

## Credits

- Launch screen photo: marble copy of the *Farnese Hercules*, from [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Marble_copy_of_the_famous,_bronze_%E2%80%9CHercules_Farnese%E2%80%9D_03.jpg), released under CC0 (no rights reserved).
- Launch screen quote: Alexis Carrel.
