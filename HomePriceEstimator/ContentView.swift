//
//  ContentView.swift
//  HomePriceEstimator
//
//  Created by Jaime Vega on 4/15/24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    var homePriceRegresionModel: HomePriceRegressor
    
    init() {
        do {
            homePriceRegresionModel = try HomePriceRegressor(configuration: MLModelConfiguration())
        } catch {
            fatalError("Error initializing model: \(error)")
        }
    }
    
    private enum NumberOfBedrooms: Int64, CaseIterable, Identifiable {
        case one
        case two
        case three
        case four
        case five
        case six
        
        var textDescription: String {
            switch self {
                case .one:
                    return "1"
                case .two:
                    return "2"
                case .three:
                    return "3"
                case .four:
                    return "4"
                case .five:
                    return "5"
                case .six:
                    return "6"
            }
        }
        var id: Self { self }
    }
    
    private enum NumberOfBathrooms: Int64, CaseIterable, Identifiable {
        
        case one
        case two
        case three
        case four
        case five
        
        var textDescription: String {
            switch self {
                case .one:
                    return "1"
                case .two:
                    return "2"
                case .three:
                    return "3"
                case .four:
                    return "4"
                case .five:
                    return "5"
            }
        }
        var id: Self { self }
    }
    
    private enum NumberOfParkingSpaces: Int64, CaseIterable, Identifiable {
        case none
        case one
        case two
        case three
        case four
        case five
        
        var textDescription: String {
            switch self {
                case .none:
                    return "None"
                case .one:
                    return "1"
                case .two:
                    return "2"
                case .three:
                    return "3"
                case .four:
                    return "4"
                case .five:
                    return "5"
            }
        }
        var id: Self { self }
    }
    
    private var formInsets = EdgeInsets(top: 0,leading: 90.0, bottom: 0, trailing: 90.0)
    @State private var homePrice = 0.0
    @State private var bedrooms: NumberOfBedrooms = .one
    @State private var bathrooms: NumberOfBathrooms = .one
    @State private var parkingSpaces: NumberOfParkingSpaces = .none
    @State private var garageSpaces: NumberOfParkingSpaces = .none
    @State private var squareFootage: Int64 = 0
    @State private var lotSize: Int64 = 0
    @State private var cornerLot: Bool = false
    @State private var waterfront: Bool = false
    
    var formatter: NumberFormatter = {
        let formatter  = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        
        
        Text(formatter.string(from: NSNumber(value: homePrice)) ?? "0.0")
            .font(.title)
            .padding()
        
        VStack {
            Text("Number of Bedrooms")
            Picker("Number of Bedrooms", selection: $bedrooms) {
                ForEach(NumberOfBedrooms.allCases) { bedroomCount in
                    Text(bedroomCount.textDescription.capitalized)
                }
            }
            .labelsHidden()
            Text("Number of Bathrooms")
            Picker("Number of Bathrooms", selection: $bathrooms) {
                ForEach(NumberOfBathrooms.allCases) { bathroomCount in
                    Text(bathroomCount.textDescription.capitalized)
                }
            }
            .labelsHidden()
            Text("Number of Garage Spaces")
            Picker("Number of Garage Spaces", selection: $garageSpaces) {
                ForEach(NumberOfParkingSpaces.allCases) { garageCount in
                    Text(garageCount.textDescription.capitalized)
                }
            }
            .labelsHidden()
            Text("Number of Parking Spaces")
            Picker("Number of Parking Spaces", selection: $parkingSpaces) {
                ForEach(NumberOfParkingSpaces.allCases) { parkingCount in
                    Text(parkingCount.textDescription.capitalized)
                }
            }
            .labelsHidden()
            Text("Square Footage")
            TextField("Square Footage", value: $squareFootage, formatter: NumberFormatter())
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .padding(formInsets)
                .multilineTextAlignment(.center)
            Text("Lot Size")
            TextField("Lot Size", value: $lotSize, formatter: NumberFormatter())
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .padding(formInsets)
                .multilineTextAlignment(.center)
            Text("Corner Lot")
            Toggle("Corner Lot", isOn: $cornerLot)
                .padding(formInsets)
                .labelsHidden()
            Text("Waterfront")
            Toggle("Waterfront", isOn: $waterfront)
                .padding(formInsets)
                .labelsHidden()
            Button("Estimate") {
                let homePriceInput = HomePriceRegressorInput(bedrooms: bedrooms.rawValue,
                                                              bathrooms: bathrooms.rawValue,
                                                             square_feet: squareFootage,
                                                              parking_spaces: parkingSpaces.rawValue,
                                                              garage_spaces: garageSpaces.rawValue,
                                                             corner: cornerLot ? "yes" : "no",
                                                              lot_size: lotSize,
                                                             
                                                              water_front: waterfront ? "yes" : "no")
                    
                do {
                    let homePriceOutput = try homePriceRegresionModel.prediction(input: homePriceInput)
                    homePrice = homePriceOutput.price
                } catch {
                    print("Error predicting home price: \(error)")
                }
            }
            .padding(EdgeInsets(top: 30.0, leading: 50.0, bottom: 0, trailing: 50.0))
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
