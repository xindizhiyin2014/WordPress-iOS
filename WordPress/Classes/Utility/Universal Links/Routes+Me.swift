import Foundation

struct MeRoute: Route {
    let path = "/me"
    let action: NavigationAction = MeNavigationAction.root
}

struct MeAccountSettingsRoute: Route {
    let path = "/me/account"
    let action: NavigationAction = MeNavigationAction.accountSettings
}

struct MeNotificationSettingsRoute: Route {
    let path = "/me/notifications"
    let action: NavigationAction = MeNavigationAction.notificationSettings
}

enum MeNavigationAction: NavigationAction {
    case root
    case accountSettings
    case notificationSettings

    func perform(_ values: [String: String] = [:], source: UIViewController? = nil) {
        switch self {
        case .root:
            WPTabBarController.sharedInstance().showMeScene()
            if !FeatureFlag.meMove.enabled {
                WPTabBarController.sharedInstance().popMeTabToRoot()
            }
        case .accountSettings:
            WPTabBarController.sharedInstance().navigateToAccountSettings()
        case .notificationSettings:
            WPTabBarController.sharedInstance().switchNotificationsTabToNotificationSettings()
        }
    }
}
