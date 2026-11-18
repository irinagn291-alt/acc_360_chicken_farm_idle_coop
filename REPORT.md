# Farm Idle: Coop — implementation report

Implemented a native universal iPhone/iPad farm game with a larger adaptive iPad yard. Features: timestamp-based egg production, grain consumption, nest limits, offline progress, collecting and selling eggs for game-only coins, hens, three upgrade branches with prerequisites and four levels each, three renewable neighbor orders, daily care streak, weekly fair with three tasks and one-time reward, free grain foraging to recover from empty resources, atomic local saves, backup recovery, confirmed farm reset, and localized opt-in local reminders.

WidgetKit provides small (care streak), medium (ready/collected eggs), large (yard, hens, grain, neighbor orders), and Lock Screen inline/circular/rectangular families from an App Group snapshot. No Live Activity is used, as required by the individual concept. The app has no network path or external API dependency. No unrelated sensitive permissions, tracking, ads, real-money flows or account are present. Production starts from documented starter supplies. Widget rendering fixtures are explicitly labeled as fixtures in QA attachments.

The product uses five Swift files plus one QA file, with a distinct vocabulary and newly generated project identifiers. EN, DE, FR and PT-BR cover all 110 UI/widget/reminder strings, the InfoPlist catalog and store metadata. The custom icon was generated with built-in image_gen; the exact prompt and final asset are under Resources.

## Files

- Xcode project: `MeadowQuill.xcodeproj`; shared scheme: `MeadowQuill`.
- Source delivery: `Artifacts/MeadowQuill-Source.zip`.
- Unsigned iOS archive: `Artifacts/MeadowQuill-iOS.xcarchive`; zipped archive: `Artifacts/MeadowQuill-iOS-unsigned.zip`.
- Local engine verification: `QA/engine-check.log`.
- Build logs: `QA/build-simulator.log`, `QA/build-release-final.log`.
- Device result bundles, screenshots and saved farm evidence: `QA/iPhone*`, `QA/iPad*`.
- Audits: `QA/final-audit.json`, `QA/device-status.json`, `Artifacts/SHA256.json`.

## Verification

The state-engine checks pass: elapsed-time production, feed exhaustion, storage limits, backward clock handling, nonduplicate collection, virtual economy, order renewal, upgrade dependencies, free-resource recovery, care streak, fair rollover, save round trip and invalid-state detection. The simulator build including widget and UI-test targets succeeds. A Release iOS archive succeeds without signing; the final archive is audited for machine/user path traces. Current device results are recorded in `QA/device-status.json` and the accompanying result bundles; no queued or running test is counted as passed.

UI scenarios cover cold start, foraging cooldown, buying grain and a hen, orders/fair screens, reminder explanation and denial, relaunch, all additional locales, widget rendering fixtures and a real timestamp-produced egg collection and sale. Whole-device sessions run through the factory pool, use only the leased device identifier, disable parallel testing, and save evidence before the helper disposes of the device.

The first iPad device pass is preserved under `QA/iPad-first*`: the app cold-started successfully, localized screens were captured, the fixture widget rendering test passed, and a real produced egg was collected. Its overall UI test suite failed because the harness assumed an iPhone-style TabBar; iPad uses floating tab cells. The harness was corrected to find navigation elements independently of their container. Visual review also found a cropped roof in the compact widget drawing; that drawing, its Lock Screen text sizing and its fixture background were refined, and the product/test targets were rebuilt successfully (`QA/build-widget-refinement.log`). The repeat iPad pass and first iPhone pass are queued behind other factory jobs, so full device QA is **not yet verified**. Neither pending run is counted as passed. The foreground script automatically exports results and refreshes this status and the delivery archives when it exits, including on a test failure.

## SDK resolutions and limits

A WidgetKit extension is necessary, so there is one app target plus the widget extension and a QA-only test target. The individual no-Live-Activity rule overrides the generic Live Activity plist shorthand. Reminder wording describes eggs ready for collection instead of pretending eggs were automatically gathered. Push entitlement and the requested remote-notification mode are declared; there is no remote push transport, registration, backend or promise of live delivery. Apple controls widget refresh and notification presentation; timelines project local farm state without network access. Relevant primary Apple documentation is linked in README.

Physical-device provisioning, distribution signing, APNs delivery and App Store submission are outside this local implementation and have not been performed. App Groups/push on a signed physical build require the publisher's Apple team. A public privacy-policy URL and support contact have not been supplied and must be added by the publisher before submission. Lock Screen placement and background scheduling cannot be equated with static widget-rendering fixtures; only executed device checks are claimed in the final QA status. Store publication and paid actions were not performed.

<!-- DEVICE STATUS -->
## Current device QA status

- iPhone: waiting for factory simulator pool
- iPad: waiting for factory simulator pool
