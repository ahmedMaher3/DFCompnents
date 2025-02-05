//
//  SliderView.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/3/25.
//

import SwiftUI

struct SliderView: View {
    @ObservedObject var viewModel: SliderViewModel
    @State private var sliderValue: Double = 50
        var range: ClosedRange<Double> = 0...100
        var step: Double = 1
    
    @State private var value1: Double = 0
    @State private var value2: Double = 0
    
    @State private var selection: ClosedRange<CGFloat> = 30...50
    

        var body: some View {
            VStack(spacing: 20) {
                
                HStack {
                    Slider(
                        value: $viewModel.value,
                        in: viewModel.field.minimumValue...viewModel.field.maximumValue,
                        step: viewModel.field.step
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text(viewModel.field.minimumValue.formatted())
                    } maximumValueLabel: {
                        Text(viewModel.field.maximumValue.formatted())
                    }
                    Button {
                        viewModel.value = 0
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                }
//                CustomSliderOLD(range: 0...100)
//                CustomSlider(value: $sliderValue, range: range, step: step)
//                    .padding()

//                Text("Current Value: \(Int(sliderValue))")
//                    .font(.title)
                
                HStack {
                    RangeSliderView(selection: $selection, range: 0...100)
                    Button {
                        selection = 0...0
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                }
                
                Text("\(Int(selection.lowerBound))/\(Int(selection.upperBound))")
                
//                RangeSliderViewGPT(lowerValue: $value1, upperValue: $value2, range: 0...100)
                
//                RangeSlider()
            }
            .padding()
        }
//    @ObservedObject var viewModel: SliderViewModel
//    
//    @State private var isEditing = false
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(viewModel.field.title)
//                .font(.headline)
//            Slider(
//                value: $viewModel.value,
//                in: viewModel.field.minimumValue...viewModel.field.maximumValue,
//                step: viewModel.field.step
//            ) {
//                Text("Speed")
//            } minimumValueLabel: {
//                Text(viewModel.field.minimumValue.formatted())
//            } maximumValueLabel: {
//                Text(viewModel.field.maximumValue.formatted())
//            } onEditingChanged: { editing in
//                isEditing = editing
//            }
//            Text(viewModel.value.formatted())
//                    .foregroundColor(.blue)
//        }
//        .padding()
//    }
}

struct CustomSliderOLD: View {
    @State private var value: Double = 50
    var range: ClosedRange<Double>

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Default Slider
                Slider(value: $value, in: 0...100)
                    .padding(.horizontal, 20)

                // Overlaying Text on the Thumb
                Text("\(Int(value))")
                    .foregroundColor(.white)
                    .font(.caption)
                    .bold()
                    .padding(5)
                    .background(Circle().fill(Color.blue))
                    .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * (geometry.size.width - 30))
            }
        }
        .frame(height: 50)
        .padding()
    }
}

struct CustomSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Slider Track
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(.gray.opacity(0.3))

                // Slider Thumb with Text
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                    Text("\(Int(value))")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * (geometry.size.width - 30))
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let newValue = Double(gesture.location.x / geometry.size.width) * (range.upperBound - range.lowerBound) + range.lowerBound
                            value = min(max(newValue, range.lowerBound), range.upperBound)
                        }
                )
            }
        }
        .frame(height: 30)
    }
}

struct RangeSliderView: View {
    @Binding var selection: ClosedRange<CGFloat>
    var range: ClosedRange<CGFloat>
    var minimumDistance: CGFloat = 0
    var tint: Color = .blue
    
    @State private var slider1 = GestureProperties()
    @State private var slider2 = GestureProperties()
    @State private var indicatorWidth: CGFloat = 0
    @State private var isInitial = false
    @State private var isDragging = false
    
    var body: some View {
        HStack(spacing: 10) {
            Text("0")
            GeometryReader { geometry in
                let maxSliderWidth = geometry.size.width - 30
                let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(tint.tertiary)
                        .frame(height: 5)
                    
                    //Sliders
                    HStack(spacing: 0) {
                        Circle()
                            .fill(tint)
                            .frame(width: 20, height: 20)
                            .contentShape(.rect)
                            .overlay(alignment: .leading, content: {
                                Rectangle()
                                    .fill(tint)
                                    .frame(width: indicatorWidth, height: 5)
                                    .offset(x: 20)
                                    .allowsHitTesting(false)
                                
                            })
                            .offset(x: slider1.offset)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        isDragging = true
                                        var translation = value.translation.width + slider1.lastStoredOffset
                                        translation = min(max(translation, 0), slider2.offset - minimumDistance)
                                        slider1.offset = translation
                                        
                                        calculateNewRange(geometry.size)
                                    }
                                    .onEnded { _ in
                                        isDragging = false
                                        slider1.lastStoredOffset = slider1.offset
                                    }
                            )
                            .overlay(
                                Text("\(Int(selection.lowerBound))")
                                    .font(.system(size: 12))
                                    .minimumScaleFactor(0.2)
                                    .offset(x: slider1.offset, y: -20)
                            )
                        
                        Circle()
                            .fill(tint)
                            .frame(width: 20, height: 20)
                            .contentShape(.rect)
                            .offset(x: slider2.offset)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        isDragging = true
                                        var translation = value.translation.width + slider2.lastStoredOffset
                                        translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
                                        slider2.offset = translation
                                        
                                        calculateNewRange(geometry.size)
                                    }
                                    .onEnded { _ in
                                        isDragging = false
                                        slider2.lastStoredOffset = slider2.offset
                                    }
                            )
                            .overlay(
                                Text("\(Int(selection.upperBound))")
                                    .font(.system(size: 12))
                                    .minimumScaleFactor(0.2)
                                    .offset(x: slider2.offset, y: -20)
                                
                            )
                    }
                }
                .frame(width: .infinity)
                .task {
                    guard !isInitial else { return }
                    isInitial = true
                    try? await Task.sleep(for: .seconds(0))
                    setSliderValues(value: selection, in: geometry)
                }
                .onChange(of: selection) { _, newValue in
                    if !isDragging {
                        setSliderValues(value: newValue, in: geometry)
                    }
                }
            }
            .frame(height: 20)
            
            Text("100")
        }
    }
    
    fileprivate func setSliderValues(value: ClosedRange<CGFloat>, in geometry: GeometryProxy) {
        let maxWidth = geometry.size.width - 30
        
        let start = value.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
        let end = value.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
        
        slider1.offset = start
        slider1.lastStoredOffset = start
        slider2.offset = end
        slider2.lastStoredOffset = end
        
        calculateNewRange(geometry.size)
    }
    
    private func calculateNewRange(_ size: CGSize) {
        indicatorWidth = slider2.offset - slider1.offset
        
        let maxWidth = size.width - 30
        
        let startProgress = slider1.offset / maxWidth
        let endProgress = slider2.offset / maxWidth
        
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
        
        selection = newRangeStart...newRangeEnd
    }
    
    private struct GestureProperties {
        var offset: CGFloat = 0
        var lastStoredOffset: CGFloat = 0
    }
}

struct RangeSliderViewGPT: View {
    @Binding var lowerValue: Double
    @Binding var upperValue: Double
    let range: ClosedRange<Double>

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let lowerX = CGFloat(lowerValue) * width
            let upperX = CGFloat(upperValue) * width

            ZStack {
                // Background track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 6)
                
                // Highlighted range
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue)
                    .frame(width: upperX - lowerX, height: 6)
                    .offset(x: lowerX)

                // Lower thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .position(x: lowerX, y: 20)
                    .gesture(DragGesture().onChanged { value in
                        let newValue = min(max(0, value.location.x / width), upperValue - 0.05)
                        lowerValue = newValue
                    })

                // Upper thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .position(x: upperX, y: 20)
                    .gesture(DragGesture().onChanged { value in
                        let newValue = max(min(1, value.location.x / width), lowerValue + 0.05)
                        upperValue = newValue
                    })
            }
        }
    }
}

struct RangeSlider: View {
    @State private var lowerValue: CGFloat = 0.2
    @State private var upperValue: CGFloat = 0.8
    private let totalRange: ClosedRange<CGFloat> = 0...1

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)

                    // Selected Range
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: self.widthForSelectedRange(in: geometry.size.width))
                        .offset(x: self.offsetForLowerValue(in: geometry.size.width))

                    // Lower Thumb
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 3)
                        .frame(width: 24, height: 24)
                        .offset(x: self.offsetForLowerValue(in: geometry.size.width) - 12)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.updateLowerValue(with: value, in: geometry.size.width)
                                }
                        )

                    // Upper Thumb
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 3)
                        .frame(width: 24, height: 24)
                        .offset(x: self.offsetForUpperValue(in: geometry.size.width) - 12)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.updateUpperValue(with: value, in: geometry.size.width)
                                }
                        )
                }
            }
            .frame(height: 24)

            Text("Lower: \(lowerValue, specifier: "%.2f")")
            Text("Upper: \(upperValue, specifier: "%.2f")")
        }
        .padding()
    }

    // Helper functions
    private func widthForSelectedRange(in totalWidth: CGFloat) -> CGFloat {
        return (upperValue - lowerValue) * totalWidth
    }

    private func offsetForLowerValue(in totalWidth: CGFloat) -> CGFloat {
        return lowerValue * totalWidth
    }

    private func offsetForUpperValue(in totalWidth: CGFloat) -> CGFloat {
        return upperValue * totalWidth
    }

    private func updateLowerValue(with gestureValue: DragGesture.Value, in totalWidth: CGFloat) {
        let newValue = gestureValue.location.x / totalWidth
        lowerValue = min(max(newValue, totalRange.lowerBound), upperValue)
    }

    private func updateUpperValue(with gestureValue: DragGesture.Value, in totalWidth: CGFloat) {
        let newValue = gestureValue.location.x / totalWidth
        upperValue = max(min(newValue, totalRange.upperBound), lowerValue)
    }
}

#Preview {
//    SliderView(viewModel: SliderViewModel())
    SliderView(viewModel: SliderViewModel())
}

extension CGFloat {
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] {
            return outputRange[0]
        }
        
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            
            if x <= inputRange[index] {
                let y = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
                return y
            }
        }
        return outputRange[length]
    }
}
