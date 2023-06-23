//
//  ContentView.swift
//  DiceRolling
//
//  Created by Giorgio Latour on 6/21/23.
//

import SwiftUI

struct ContentView: View {
    @State private var dieOneValue = 1
    @State private var dieTwoValue = 1
    @State private var maxValue = 4
    @State private var showingSettingsView = false
    
    @StateObject private var rolls = DiceRolls()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 20) {
                    Button {
                        withAnimation {
                            dieOneValue = Int.random(in: 1...maxValue)
                            dieTwoValue = Int.random(in: 1...maxValue)
                            
                            rolls.addRoll(
                                DiceRoll(
                                    dieOneValue: self.dieOneValue,
                                    dieTwoValue: self.dieTwoValue
                                )
                            )
                        }
                    } label: {
                        Text("Roll Dice")
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.bordered)
                    
                    HStack {
                        Text("Sides:")
                        Picker("Sides", selection: $maxValue) {
                            ForEach([4, 6, 8, 10, 12, 20, 100], id: \.self) { sides in
                                Text("\(sides)")
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
                HStack {
                    DieView(dieValue: String(dieOneValue))
                    DieView(dieValue: String(dieTwoValue))
                }
                
                Text("Total: \(dieOneValue + dieTwoValue)")
                
                Form {
                    Section("Previous Rolls") {
                        List(rolls.rolls) { roll in
                            HStack {
                                Text("\(roll.dieOneValue), \(roll.dieTwoValue)")
                                Spacer()
                                Text("Total: \(roll.dieOneValue + roll.dieTwoValue)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dice Roller")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettingsView = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
        }
    }
}

struct DieView: View {
    var dieValue: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.black)
                .frame(width: 100, height: 100)
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: 85, height: 85)
            Text(dieValue)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
    
    init(dieValue: String = "1") {
        self.dieValue = dieValue
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
