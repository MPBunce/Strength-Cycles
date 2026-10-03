# Forge App Store assets

## Icon (`icon/`)
- `AppIcon-1024.png`: App Store icon, 1024 × 1024, no transparency. App Store Connect uses the icon from the uploaded build, so this copy is for reference, the website and marketing.
- `AppIcon-1024-Dark.png`, `AppIcon-1024-Tinted.png`: the iOS dark and tinted variants.

## Screenshots (`screenshots/`)
Three sets with the same images:

- `6.5-inch/`: 1284 × 2778. Use this if App Store Connect asks for 1242 × 2688 or 1284 × 2778.
- `6.9-inch/`: 1320 × 2868, for the 6.9" display slot.
- `13-inch-ipad/`: 2064 × 2752, for the 13" iPad display slot (taken on an iPad Pro 13-inch simulator). App Store Connect scales these down for smaller iPads.

App Store Connect scales these down for smaller iPhones. Upload in this order:

1. `01-launch.png`: launch screen
2. `02-today.png`: Today: steps and daily work
3. `03-training-strength.png`: strength cycles
4. `04-training-running.png`: runs, races and plans
5. `05-progress-activity.png`: activity grids
6. `06-progress-charts.png`: strength charts
7. `07-progress-goals.png`: goals

App Store Connect accepts up to 10 screenshots per size.

## Regenerating
The screenshots use sample data from `Forge/DemoData.swift` (development builds only, kept in memory). On the iPhone 17 Pro Max simulator (use an iPad Pro 13-inch simulator for `13-inch-ipad/`):

```bash
xcrun simctl status_bar booted override --time "9:41" --batteryState charged --batteryLevel 100
xcrun simctl launch booted mpbunce.Strength-Cycles -ForgeDemoData -ForgeTab 2 -ForgeProgress Charts
xcrun simctl io booted screenshot assets/screenshots/6.9-inch/06-progress-charts.png
```

Make the 6.5" copies with `swift assets/resize.swift assets/screenshots/6.9-inch assets/screenshots/6.5-inch` (scales to 1284 wide and trims a few pixels top and bottom).

`-ForgeTab` is 0 Today, 1 Training, 2 Progress, 3 Settings. `-ForgeTraining running` opens the Running section; `-ForgeProgress` takes `Activity`, `Charts` or `Goals`.
