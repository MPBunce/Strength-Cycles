import Foundation

struct MentzerTrainingDays {
    
    static let trainingSessions: [TrainingDay] = [
        // Workout 1: Chest & Back
        TrainingDay(day: [
            // Chest
            Exercise(name: "Dumbbell flyes", sets: [Set(weight: 0, reps: 8)]), // 1 × 6–10 reps
            Exercise(name: "Incline presses", sets: [Set(weight: 0, reps: 2)]), // 1 × 1–3 reps
            // Back
            Exercise(name: "Straight-arm pulldowns", sets: [Set(weight: 0, reps: 8)]), // 1 × 6–10 reps
            Exercise(name: "Palms-up pulldowns", sets: [Set(weight: 0, reps: 8)]), // 1 × 6–10 reps
            Exercise(name: "Deadlifts", sets: [Set(weight: 0, reps: 8)]) // 1 × 6–10 reps
        ], completedDate: nil),
        
        // Workout 2: Legs & Abs
        TrainingDay(day: [
            // Legs
            Exercise(name: "Leg extensions", sets: [Set(weight: 0, reps: 16)]), // 1 × 12–20
            Exercise(name: "Leg presses", sets: [Set(weight: 0, reps: 16)]), // 1 × 12–20
            Exercise(name: "Standing calf raises", sets: [Set(weight: 0, reps: 16)]), // 1 × 12–20
            // Abs
            Exercise(name: "Sit-ups", sets: [Set(weight: 0, reps: 16)]) // 1 × 12–20
        ], completedDate: nil),
        
        // Workout 3: Shoulders & Arms
        TrainingDay(day: [
            // Shoulders
            Exercise(name: "Dumbbell lateral raises", sets: [Set(weight: 0, reps: 8)]), // 1 × 6–10 reps
            Exercise(name: "Bent-over dumbbell laterals", sets: [Set(weight: 0, reps: 8)]), // 1 × 6–10 reps
            // Biceps
            Exercise(name: "Palms-up pulldowns", sets: [Set(weight: 0, reps: 8)]), // 1 × 6–10 reps
            // Triceps
            Exercise(name: "Triceps pressdowns", sets: [Set(weight: 0, reps: 8)]), // 1 × 6–10 reps
            Exercise(name: "Dips", sets: [Set(weight: 0, reps: 4)]) // 1 × 3–5 reps
        ], completedDate: nil),
        
        // Workout 4: Legs & Abs
        TrainingDay(day: [
            // Legs
            Exercise(name: "Leg extensions", sets: [Set(weight: 0, reps: 16)]), // 1 × 12–20
            Exercise(name: "Leg presses", sets: [Set(weight: 0, reps: 16)]), // 1 × 12–20
            Exercise(name: "Standing calf raises", sets: [Set(weight: 0, reps: 16)]), // 1 × 12–20
            // Abs
            Exercise(name: "Sit-ups", sets: [Set(weight: 0, reps: 16)]) // 1 × 12–20
        ], completedDate: nil)
    ]
}
