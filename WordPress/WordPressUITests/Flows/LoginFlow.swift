import XCTest

class LoginFlow {

    @discardableResult
    static func login(siteUrl: String, username: String, password: String) -> MySiteScreen {
        logoutIfNeeded()

        return PrologueScreen().selectSiteAddress()
            .proceedWith(siteUrl: siteUrl)
            .proceedWith(username: username, password: password)
            .continueWithSelectedSite()
            .dismissNotificationAlertIfNeeded()

        // TODO: remove when unifiedAuth is permanent.
        // Leaving here for now in case unifiedAuth is disabled.
//        return WelcomeScreen().selectLogin()
//            .goToSiteAddressLogin()
//            .proceedWith(siteUrl: siteUrl)
//            .proceedWith(username: username, password: password)
//            .continueWithSelectedSite()
//            .dismissNotificationAlertIfNeeded()
    }

    static func loginIfNeeded(siteUrl: String, username: String, password: String) -> TabNavComponent {
        guard TabNavComponent.isLoaded() else {
            return login(siteUrl: siteUrl, username: username, password: password).tabBar
        }
        return TabNavComponent()
    }

    static func logoutIfNeeded() {
        XCTContext.runActivity(named: "Log out of app if currently logged in") { (activity) in
            if TabNavComponent.isLoaded() {
                Logger.log(message: "Logging out...", event: .i)
                let meScreen = TabNavComponent().gotoMeScreen()
                if meScreen.isLoggedInToWpcom() {
                    _ = meScreen.logoutToPrologue()
                } else {
                    _ = TabNavComponent().gotoMySiteScreen()
                        .removeSelfHostedSite()
                }
                return
            }
        }

        XCTContext.runActivity(named: "Return to app prologue screen if needed") { (activity) in
            if !WelcomeScreen.isLoaded() {
                while LoginPasswordScreen.isLoaded() || LoginEmailScreen.isLoaded() || LinkOrPasswordScreen.isLoaded() || LoginSiteAddressScreen.isLoaded() || LoginUsernamePasswordScreen.isLoaded() || LoginCheckMagicLinkScreen.isLoaded() {
                    if LoginEmailScreen.isLoaded() && LoginEmailScreen.isEmailEntered() {
                        LoginEmailScreen().emailTextField.clearTextIfNeeded()
                    }
                    navBackButton.tap()
                }
            }
        }
    }
}
