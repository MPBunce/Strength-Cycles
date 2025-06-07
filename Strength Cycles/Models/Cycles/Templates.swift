struct Template: Identifiable {
    let id: String
    let name: String
    let description: String
    let duration: String
    let trainingDays: [TrainingDay]
}

extension Template {
    static func loadTemplates() -> [Template] {
        return [
            Template(
                id: "classic-menzer",
                name: "Classic Menzer Cycle",
                description: "High-intensity training with extended rest periods",
                duration: "4 days",
                trainingDays: MenzerProgram().copyTrainingDays() // ensure new instances
            ),
            Template(
                id: "modern-menzer",
                name: "Modern Menzer Cycle",
                description: "High-intensity training with extended rest periods",
                duration: "4 days",
                trainingDays: ModernMenzerProgram().copyTrainingDays() // ensure new instances
            ),
            Template(
                id: "ppl",
                name: "Push Pull Legs",
                description: "Split training focusing on movement patterns",
                duration: "3 days",
                trainingDays: []
            ),
            Template(
                id: "upper_lower",
                name: "Upper Lower Split",
                description: "4-day split alternating upper and lower body",
                duration: "4 days",
                trainingDays: []
            )
        ]
    }
}
