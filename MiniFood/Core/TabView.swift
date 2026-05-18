//
//  TabView.swift
//  MiniFood
//
//  Created by Thiago Lourenço on 10/05/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItemModel = .home
    @State private var isTabBarVisible = true
    @State private var showVisibleTest: Bool = false

    var body: some View {
        ZStack() {
            Spacer()
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                        .animation(.bouncy(duration: 0.4), value: showVisibleTest)
                        .onAppear {
                            withAnimation(.bouncy) {
                                showVisibleTest = true
                            }
                        }
                case .orders:
                    HomeView()
                case .privacy:
                    HomeView()
                case .profile:
                    HomeView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .tabBarVisibility($isTabBarVisible)
        .safeAreaInset(edge: .bottom) {
            if isTabBarVisible {
                HStack(spacing: 24) {
                    ForEach(TabItemModel.allCases, id: \.self) { tab in
                        Button {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                self.selectedTab = tab
                            }
                        } label: {
                            VStack {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 18, weight: .regular, design: .default))
                                    .foregroundStyle(selectedTab == tab ? Color("Primary") : Color("Black700").opacity(0.4))

                                Spacer()

                                Text(tab.title)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .foregroundStyle(selectedTab == tab ? Color("Primary") : Color("Black700").opacity(0.4))
                            }
                        }
                        .frame(height: 40)
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
                .background(Color("White"))
                .shadow(color: Color("Black").opacity(0.4), radius: 2, y: 2)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(TabBarVisibility.animation, value: isTabBarVisible)
    }
}

#Preview {
    MainTabView()
}

