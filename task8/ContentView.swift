//
//  ContentView.swift
//  task8
//
//  Created by Nikolay Volnikov on 22.10.2023.
//

import SwiftUI

struct ContentView: View {
    private var sliderHeight: CGFloat = 180

    @State var progress: Double = 0
    @State var lastDragValue: Double = 0
    @State var heightScale: Double = 1
    @State var widthScale: Double = 1
    @State var dragSide: UnitPoint = .zero
    @State var offset: CGFloat = 0

    var body: some View {
        ZStack {
            Image("1")
                .padding(.bottom, 500)
                .background(.black)

            RoundedRectangle(cornerRadius: 18.0)
                .fill(.ultraThinMaterial)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.blue)
                        .scaleEffect(y: progress, anchor: .bottom)
                        .clipShape(RoundedRectangle(cornerRadius: 18.0))
                }
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { value in
                            let newValue = -value.translation.height / sliderHeight + lastDragValue

                            switch newValue {
                            case _ where newValue > 1:
                                progress = 1
                                heightScale = pow(newValue, 1/8)
                                widthScale = 1 / pow(newValue, 1/10)
                                dragSide = .bottom
                                offset = -2 * newValue

                            case _ where newValue < 0:
                                progress = 0
                                heightScale = pow(1 - newValue, 1/8)
                                widthScale = 1 / pow(1 - newValue, 1/10)
                                dragSide = .top
                                offset = -2 * newValue

                            default:
                                progress = newValue
                                offset = 0
                            }
                        }
                        .onEnded({ _ in
                            lastDragValue = progress
                            heightScale = 1
                            widthScale = 1
                            offset = 0
                        })
                )
                .frame(width: 80, height: sliderHeight)
                .scaleEffect(
                    x: widthScale,
                    y: heightScale,
                    anchor: dragSide
                )
                .animation(.default, value: heightScale)
                .animation(.default, value: offset)
                .offset(y: offset)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
