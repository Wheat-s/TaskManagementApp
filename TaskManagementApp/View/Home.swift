//
//  Home.swift
//  TaskManagementApp
//
//  Created by wheat on 7/10/25.
//

import SwiftUI

struct Home: View {
    // View Properties
    @State private var currentWeek: [Date] = Date.currentWeek
    @State private var selectedDate: Date?
    // For Matched Geometry Effect
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .environment(\.colorScheme, .dark)
            
            GeometryReader {_ in 
//                let size = $0.size
                
            }
            .background(.background)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 30,style: .continuous))
            .environment(\.colorScheme, .light)
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .background(.mainBackground)
        .onAppear{
            /// Setting up initial Selection Date
            guard selectedDate == nil else { return }
            
            /// Today''s Date
            selectedDate = currentWeek.first(where: { $0.isSame(date: .now)})
        }
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This Week")
                    .font(.title.bold())
                    
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image(.pic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(.circle)
                }
            }
            
            /// Week View
            HStack(spacing: 0) {
                ForEach(currentWeek, id: \.self) { date in
                    let isSameDate = date.isSame(date: selectedDate)
                    VStack(spacing: 6) {
                        Text(date.string(format: "EEE"))
                            .font(.caption)
                        
                        Text(date.string(format: "dd"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(isSameDate ? .black : .white)
                            .frame(width: 38, height: 38)
                            .background {
                                if isSameDate {
                                    Circle()
                                        .fill(.white)
                                        .matchedGeometryEffect(id: "ACTIVEDATE", in: namespace)
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            selectedDate = date
                        }
                    }
                }
            }
            .frame(height: 80)
            .padding(.vertical, 5)
            .offset(y: 5)
            
            HStack {
                Text(selectedDate?.string(format: "M月") ?? "")
                Spacer()
                
                Text(selectedDate?.string(format: "YYYY") ?? "")
            }
            .font(.caption2)
        }
        .padding([.horizontal, .top], 15)
        .padding(.bottom, 10)
    }
}

#Preview {
    Home()
}
