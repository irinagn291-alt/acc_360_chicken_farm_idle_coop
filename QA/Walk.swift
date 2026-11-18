import XCTest
final class pzWalk:XCTestCase {
 func nav(_ label:String,_ app:XCUIApplication) {let t=app.descendants(matching:.any).matching(NSPredicate(format:"label == %@",label)).firstMatch;XCTAssertTrue(t.waitForExistence(timeout:5));t.tap()}
 func shot(_ name:String) {let a=XCTAttachment(screenshot:XCUIApplication().screenshot());a.name=name;a.lifetime = .keepAlways;add(a)}
 func testFarmJourney() throws {
  let app=XCUIApplication();app.launchArguments += ["-AppleLanguages","(en)","-AppleLocale","en_US"];app.launch()
  XCTAssertTrue(app.buttons["settings"].waitForExistence(timeout:20));shot("01-yard-cold-start")
  nav("Barn",app);XCTAssertTrue(app.buttons["forage"].waitForExistence(timeout:5));app.buttons["forage"].tap();XCTAssertFalse(app.buttons["forage"].isEnabled);shot("02-grain-barn")
  nav("Market",app);XCTAssertTrue(app.buttons["buyGrain"].waitForExistence(timeout:5));app.buttons["buyGrain"].tap();shot("03-market")
  app.swipeUp();app.swipeUp();shot("04-neighbors-and-fair")
  nav("Grow",app);XCTAssertTrue(app.buttons["hen"].waitForExistence(timeout:5));app.buttons["hen"].tap();XCTAssertFalse(app.buttons["hen"].isEnabled);shot("05-grow")
  app.buttons["settings"].tap();XCTAssertTrue(app.buttons["enableReminders"].waitForExistence(timeout:5));shot("06-reminder-explanation")
  addUIInterruptionMonitor(withDescription:"notification permission"){alert in if alert.buttons["Don’t Allow"].exists{alert.buttons["Don’t Allow"].tap();return true};if alert.buttons["Don't Allow"].exists{alert.buttons["Don't Allow"].tap();return true};return false}
  app.buttons["enableReminders"].tap();app.tap();app.swipeUp();shot("07-local-privacy")
  app.buttons["Done"].tap();app.terminate();app.launch();XCTAssertTrue(app.buttons["settings"].waitForExistence(timeout:10));shot("08-relaunch-persisted")
 }
 func testLocalizedLaunches() {
  for (loc,title,tab) in [("de","Chicken Farm Idle: Coop","Scheune"),("fr","Chicken Farm Idle: Coop","Grange"),("pt-BR","Chicken Farm Idle: Coop","Celeiro")] {
   let a=XCUIApplication();a.launchArguments=["-AppleLanguages","(\(loc))","-AppleLocale",loc];a.launch();XCTAssertTrue(a.buttons["settings"].waitForExistence(timeout:15));XCTAssertTrue(a.descendants(matching:.any).matching(NSPredicate(format:"label == %@",tab)).firstMatch.exists);shot("locale-\(loc)");a.terminate();_ = title
  }
 }
}

import SwiftUI
import WidgetKit
extension pzWalk {
 @MainActor func testWidgetSurfaces() throws {
  var s=pzSeed();s.nest=18;s.eggs=24;s.gathered=80;s.care(Date())
  let e=pzMoment(date:Date(),s:s,started:true)
  for (family,w,h,name) in [(WidgetFamily.systemSmall,170.0,170.0,"small"),(.systemMedium,364,170,"medium"),(.systemLarge,364,382,"large"),(.accessoryRectangular,170,80,"lock")]{
   let view=pzGlance(e:e,renderFamily:family).padding(16).frame(width:w,height:h).background(pzTone.cream).environment(\.colorScheme,.light)
   let render=ImageRenderer(content:view);render.scale=2
   let img=try XCTUnwrap(render.uiImage);let a=XCTAttachment(image:img);a.name="widget-\(name)-fixture";a.lifetime = .keepAlways;add(a)
  }
 }
 func testZRealHarvest() {
  let a=XCUIApplication();a.launchArguments=["-AppleLanguages","(en)","-AppleLocale","en_US"];a.launch()
  XCTAssertTrue(a.buttons["settings"].waitForExistence(timeout:15))
  a.swipeUp();let b=a.buttons["collect"]
  let p=NSPredicate(format:"enabled == true");expectation(for:p,evaluatedWith:b);waitForExpectations(timeout:130)
  b.tap();shot("09-real-harvest")
  nav("Market",a);XCTAssertTrue(a.buttons["sell"].waitForExistence(timeout:5));XCTAssertTrue(a.buttons["sell"].isEnabled);a.buttons["sell"].tap();XCTAssertFalse(a.buttons["sell"].isEnabled);shot("10-harvest-sold")
 }
}
