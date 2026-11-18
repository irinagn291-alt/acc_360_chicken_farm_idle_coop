# Farm Idle: Coop

Native, fully offline iPhone and iPad game. Open `MeadowQuill.xcodeproj`, select the shared `MeadowQuill` scheme, and run with Xcode 27.2 or a compatible newer SDK. Deployment target: iOS 17.6. No dependencies, accounts, server, ads, purchases, or network APIs.

The farm starts with 3 hens, 80 earned-in-game currency units, 48 stored grain and 12 grain in the trough. Each hen produces one egg per 120 seconds and consumes one grain per 10 minutes. Nest and feed capacities limit offline progress. The farm offers grain foraging every 30 minutes, three repeating neighbor orders, 12 upgrade levels, additional hens, a care streak and a weekly fair resetting on Monday. The game explains its clock behavior and production rules in the Barn and Farm settings.

`Coop/Grain.swift` is the deterministic saved-state engine; `Meadow.swift` draws the farm; `Roost.swift` owns persistence and reminders; `Yard.swift` contains the adaptive native interface; `Sprig/Glance.swift` provides WidgetKit; `QA/Walk.swift` is UI QA. Six Swift files total, five in the product. The project has one application target, a required widget extension, and a QA-only UI test target.

EN, DE, FR and PT-BR include the app, widgets, notification text, InfoPlist string catalog and localized store metadata. The generated icon and its prompt are in `Resources`. Local save is atomic JSON with a recovery backup; a shared App Group snapshot supplies offline widgets. No demo state is used in production; widget fixture screenshots are explicitly named as fixtures.

## Build and QA

All outputs are scoped to this app directory. Build logs and results are in `QA`, disposable compiler products in `Artifacts/Build` and `Artifacts/ReleaseBuild`. The source delivery archive excludes these intermediate directories, logs, simulator state and user settings. The final report lists the executed checks and remaining limits.

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild -project MeadowQuill.xcodeproj -scheme MeadowQuill -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath Artifacts/Build -jobs 2 CODE_SIGNING_ALLOWED=NO build-for-testing
swiftc -parse-as-library -D COOP_VERIFY -module-cache-path Artifacts/ModuleCache Coop/Grain.swift -o QA/EngineCheck
QA/EngineCheck
```

For iOS QA, run the entire `QA/foreground.sh` through the factory's `gf/genesis/simulator_pool.py TEMPLATE_UDID bash PATH_TO_FOREGROUND_SCRIPT DEVICE_LABEL`. The script exclusively uses `$GF_SIMULATOR_UDID`, disables parallel testing and writes evidence outside the simulator. Do not directly create, erase, or operate a shared simulator.

## SDK decisions

WidgetKit needs an app extension. The separate `SprigBoard` target is required despite the single-target shorthand in the concept. Apple controls widget refresh timing; the extension provides projected local timeline entries and does not promise immediate background updates. See [TimelineProvider](https://developer.apple.com/documentation/widgetkit/timelineprovider/) and [Keeping a widget up to date](https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date).

The individual concept explicitly excludes Live Activity, so `NSSupportsLiveActivities` is false and no ActivityKit extension is claimed. App Groups are declared in both product targets. Push entitlement and remote-notification background mode are declared as explicitly requested, but there is no APNs registration or delivery service. Actual reminders use local notification requests. The wording says eggs are ready to collect, rather than claiming a collection happened automatically. The app asks permission only from its explanation screen and remains usable after denial. See [Asking permission](https://developer.apple.com/documentation/usernotifications/asking-permission-to-use-notifications) and [Local notification scheduling](https://developer.apple.com/documentation/usernotifications/scheduling-a-notification-locally-from-your-app).

Privacy manifests declare only local app and App Group UserDefaults use (CA92.1, 1C8F.1). See [Apple required-reason API documentation](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype). No unrelated sensitive permissions are declared.

The iOS archive is unsigned: installation on a physical device requires the publisher's Apple team and provisioning for the unique bundle identifiers, App Group and push capability. No paid or publishing action was performed. A public privacy policy URL and support contact belong to the publisher and must be supplied before submission. No external data API is used, so there is no free-tier availability dependency.
