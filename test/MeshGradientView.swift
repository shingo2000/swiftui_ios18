//
//  MeshGradientView.swift
//  test
//
//  Created by 鈴木慎吾 on 2024/06/15.
//


import SwiftUI


struct MeshGradientView: View {
    
    @State private var points: [SIMD2<Float>] = [
        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
        [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
    ]
    @State private var colors: [Color] = [
        .red, .purple, .indigo,
        .orange, .white, .blue,
        .yellow, .green, .mint
    ]
    
    private let initialPoints: [SIMD2<Float>] = [
        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
        [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
    ]
    
    
    private let springConstant: Float = 0.02
    private let repulsionConstant: Float = 0.015
    
    @State private var touchPoint: SIMD2<Float>? = nil
    
    var body: some View {
        GeometryReader { geometry in
            
            MeshGradient(
                width: 3,
                height: 3,
                points: points,
                colors: colors
            ).gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let touchX = Float(value.location.x / geometry.size.width)
                        let touchY = Float(value.location.y / geometry.size.height)
                        touchPoint = SIMD2<Float>(touchX, touchY)
                    }
                    .onEnded { _ in
                        touchPoint = nil
                    }
            )
            
            
            ZStack {
                ForEach(0..<points.count, id: \.self) { i in
                    let positionX = CGFloat(points[i].x) * geometry.size.width
                    let positionY = CGFloat(points[i].y) * geometry.size.height
                    Circle()
                        .fill(.clear)
                        .frame(width: 10, height: 10)
                        .position(x: positionX, y: positionY)
                }
            }
             
            .frame(width: geometry.size.width, height: geometry.size.height)
            
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                updatePoints()
            }
        }
        .edgesIgnoringSafeArea(.all) // 安全領域を無視して全画面に広げる
    }
    
    
    
    private func updatePoints() {
            for i in 0..<points.count {
                                
                var repulsionForceX: Float = 0
                var repulsionForceY: Float = 0
                
                // タッチポイントからの反発力（タッチしている場合）
                if let touchPoint = touchPoint {
                    let touchDx = touchPoint.x - points[i].x
                    let touchDy = touchPoint.y - points[i].y
                    let dist = sqrt((touchDx * touchDx) + (touchDy * touchDy))
                    let direction = atan2(touchDy, touchDx)
                    repulsionForceX = -cos(direction)/dist * repulsionConstant
                    repulsionForceY = -sin(direction)/dist * repulsionConstant
                }
                
                // 初期位置からの復元力
                let springDx = points[i].x - initialPoints[i].x
                let springDy = points[i].y - initialPoints[i].y
                let springForceX = -springConstant * springDx
                let springForceY = -springConstant * springDy
                
                
                // 総合力を適用
                points[i].x += repulsionForceX + springForceX
                points[i].y += repulsionForceY + springForceY
                
                if(points[i].x > 1){
                    points[i].x = 1
                }else if(points[i].x < 0){
                    points[i].x = 0
                }
                if(points[i].y > 1){
                    points[i].y = 1
                }else if(points[i].y < 0){
                    points[i].y = 0
                }
                
            }
        }
}

#Preview {
    MeshGradientView()
}
