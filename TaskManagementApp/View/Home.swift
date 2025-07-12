//
//  Home.swift
//  TaskManagementApp
//
//  Created by wheat on 7/10/25.
//

import SwiftUI

struct Home: View {
    // View Properties
    @State private var currentWeek: [Date.Day] = Date.currentWeek
    @State private var selectedDate: Date?
    // For Matched Geometry Effect
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .environment(\.colorScheme, .dark)
            
            GeometryReader {
                let size = $0.size
                
                ScrollView(.vertical) {
                    /// Going to use the native pinned section headers to create the header effect )saw in the intro video!)
                    LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                        ForEach(currentWeek) { day in
                            let date = day.date
                            let isLast = currentWeek.last?.id == day.id
                            
                            Section {
                                /// Use this date value to extract tasks from your database, such as SwiftData, CoreData, etc.
                                VStack(alignment: .leading, spacing: 15) {
                                    TaskRow()
                                    TaskRow()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.leading, 70)
                                .padding(.top, -70)
                                .padding(.bottom, 10)
                                /// 70: Negative Padding, 40: Content Padding
                                .frame(minHeight: isLast ? size.height - 110 : nil, alignment: .top)
                                
                            } header: {
                                VStack(spacing: 4) {
                                    Text(date.string(format: "EEE"))
                                    
                                    Text(date.string(format: "dd"))
                                        .font(.largeTitle.bold())
                                }
                                .frame(width: 55, height: 70)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.all, 20, for: .scrollContent)
                /// Only Adding Padding vertically for the indicators
                .contentMargins(.vertical, 20, for: .scrollIndicators)
                /// Using Scroll Position to identify the current active section
                .scrollPosition(id: .init(get: {
                    return currentWeek.first(where: { $0.date.isSame(date: selectedDate) })?.id
                }, set: { newValue in
                    selectedDate = currentWeek.first(where: { $0.id == newValue })?.date
                }), anchor: .top)
                /// Undoing the negative padding effect
                .safeAreaPadding(.bottom, 70)
                .padding(.bottom, -70)
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
            selectedDate = currentWeek.first(where: { $0.date.isSame(date: .now)})?.date
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
                ForEach(currentWeek) { day in
                    let date = day.date
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
            .animation(.snappy(duration: 0.25, extraBounce: 0), value: selectedDate)
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

struct TaskRow: View {
    var isEmpty: Bool = false
    var body: some View {
        Group {
            if isEmpty {
                VStack(spacing: 8) {
                    Text("No Task's found on this Day!")
                    
                    Text("Try Adding some New Tasks!")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Circle()
                        .fill(.red)
                        .frame(width: 5, height: 5)
                    
                    Text("Some Random Task")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("16:00 - 17:00")
                        
                        Spacer(minLength: 0)
                        
                        Text("Some place, California")
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(15)
                }
                .lineLimit(1)
                .padding(15)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .shadow(color: .black.opacity(0.35), radius: 1)
        }
    }
}

#Preview {
    Home()
}
