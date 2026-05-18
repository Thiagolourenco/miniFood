//
//  TabBarVisibilityHelper.swift
//  MiniFood
//

import SwiftUI

enum TabBarVisibility {
    static let animation = Animation.easeInOut(duration: 0.4)
}

// MARK: - Environment

private struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(true)
}

extension EnvironmentValues {
    var isTabBarVisible: Binding<Bool> {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}

// MARK: - Modifier

private struct HideTabBarModifier: ViewModifier {
    @Environment(\.isTabBarVisible) private var isTabBarVisible

    func body(content: Content) -> some View {
        content
            .onAppear {
                withAnimation(TabBarVisibility.animation) {
                    isTabBarVisible.wrappedValue = false
                }
            }
            .onDisappear {
                withAnimation(TabBarVisibility.animation) {
                    isTabBarVisible.wrappedValue = true
                }
            }
    }
}

// MARK: - View helpers

extension View {
    /// Publica o estado da tab bar para views filhas via Environment.
    func tabBarVisibility(_ isVisible: Binding<Bool>) -> some View {
        environment(\.isTabBarVisible, isVisible)
    }

    /// Esconde a tab bar enquanto esta view estiver na tela.
    func hidesTabBar() -> some View {
        modifier(HideTabBarModifier())
    }
}
