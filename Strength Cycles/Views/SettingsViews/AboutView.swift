//
//  AboutView.swift
//  Strength Cycles
//
//  Created by Matthew Bunce on 2025-06-15.
//

import SwiftData
import SwiftUI

// MARK: - About View
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // App Icon and Title
                VStack(spacing: 15) {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Strength Cycles")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Coming Soon Section
                VStack(spacing: 20) {
                    Text("🚧 Coming Soon 🚧")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    
                    Text("Additional settings and features are currently in development and will be available in future updates.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Text("For now, you can set your training maxes to get started with your strength training cycles.")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                // Developer Info Section
                VStack(spacing: 20) {
                    Text("Developer Info")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 15) {
                        // GitHub Repository
                        Link(destination: URL(string: "https://github.com/MPBunce/Strength-Cycles")!) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.blue)
                                Text("View on GitHub")
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        // Feature Requests
                        Link(destination: URL(string: "https://github.com/MPBunce/strength-cycles/issues/new?template=feature_request.md")!) {
                            HStack {
                                Image(systemName: "lightbulb")
                                    .foregroundColor(.orange)
                                Text("Request a Feature")
                                    .foregroundColor(.orange)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                
                // Support Section
                VStack(spacing: 20) {
                    Text("Support Development")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 15) {
                        // Buy Me a Coffee
                        /*Link(destination: URL(string: "https://buymeacoffee.com/yourusername")!) {
                            HStack {
                                Image(systemName: "cup.and.saucer")
                                    .foregroundColor(.brown)
                                Text("Buy Me a Coffee")
                                    .foregroundColor(.brown)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(.brown)
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color.brown.opacity(0.1))
                            .cornerRadius(10)
                        }*/
                        
                        // Crypto Wallet
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "bitcoinsign.circle")
                                    .foregroundColor(.orange)
                                Text("Bitcoin Wallet")
                                    .foregroundColor(.orange)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            
                            Button(action: {
                                UIPasteboard.general.string = "bc1qnegva3n5gl8vmstzwh2uv0wpxema3l22q353gt"
                            }) {
                                HStack {
                                    Text("bc1qnegva3n5gl8vmstzwh2uv0wpxema3l22q353gt")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                    Spacer()
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.orange.opacity(0.05))
                        .cornerRadius(10)
                    }
                }
                
                // Footer
                VStack(spacing: 10) {
                    Text("Built with ❤️ using SwiftUI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("© 2025 Matthew Bunce")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        AboutView()
    }
}
