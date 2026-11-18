import SwiftUI
import Combine
import WidgetKit
import UserNotifications

@MainActor final class pzNest:ObservableObject {
 @Published var x:pzSeed
 @Published var message:String?; @Published var storageNote:String?
 @Published var alerts=false; @Published var permission=""
 private var file:URL
 private let c=UNUserNotificationCenter.current()
 init() {
  let root=FileManager.default.urls(for:.applicationSupportDirectory,in:.userDomainMask)[0].appendingPathComponent("MeadowQuill",isDirectory:true)
  try? FileManager.default.createDirectory(at:root,withIntermediateDirectories:true)
  file=root.appendingPathComponent("flock-v1.json")
  var loaded:pzSeed?;var recovered=false
  for u in [file,file.appendingPathExtension("backup")] {
   if let bytes=try? Data(contentsOf:u),let a=try? JSONDecoder().decode(pzSeed.self,from:bytes),a.valid(){loaded=a;recovered=u != file;break}
  }
  x=loaded ?? pzSeed();alerts=UserDefaults.standard.bool(forKey:"care-alerts")
  if recovered {storageNote=pzL("Your farm was recovered from its local backup.")}
  if loaded==nil && FileManager.default.fileExists(atPath:file.path){
   try? FileManager.default.copyItem(at:file,to:root.appendingPathComponent("unreadable-\(Int(Date().timeIntervalSince1970)).json"));storageNote=pzL("The saved file could not be read. A fresh farm is open; the original file is kept on this device.")
  }
  x.advance(Date());save();Task {await status()}
 }
 func act(_ f:(inout pzSeed)->Void) { f(&x);save();Task{await schedule()} }
 func pulse() {x.advance(Date())}
 func checkpoint(){x.advance(Date());save();Task {await status();await schedule()}}
 func save() {
  do {
   let bytes=try JSONEncoder().encode(x)
   if let old=try? Data(contentsOf:file),let s=try? JSONDecoder().decode(pzSeed.self,from:old),s.valid(){try old.write(to:file.appendingPathExtension("backup"),options:.atomic)}
   try bytes.write(to:file,options:.atomic)
   UserDefaults(suiteName:pzGroup)?.set(bytes,forKey:"flock-snapshot")
   WidgetCenter.shared.reloadTimelines(ofKind:"meadowquill-glance")
  }catch{storageNote=pzL("Saving is unavailable. Keep the app open and free some device storage.")}
 }
 func status() async {
  let s=await c.notificationSettings()
  switch s.authorizationStatus {case .authorized,.provisional,.ephemeral: permission=pzL("Allowed");case .denied:permission=pzL("Disabled in device Settings");default:permission=pzL("Not requested")}
 }
 func request() async {
  do {let granted=try await c.requestAuthorization(options:[.alert,.sound]);alerts=granted;UserDefaults.standard.set(granted,forKey:"care-alerts");await status();await schedule()}
  catch {message=pzL("Reminders are unavailable. Your farm still works offline.")}
 }
 func disable(){alerts=false;UserDefaults.standard.set(false,forKey:"care-alerts");c.removePendingNotificationRequests(withIdentifiers:["nest","feed","fair"])}
 func schedule() async {
  c.removePendingNotificationRequests(withIdentifiers:["nest","feed","fair"])
  guard alerts else{return}
  let s=await c.notificationSettings();guard alerts && (s.authorizationStatus == .authorized || s.authorizationStatus == .provisional) else{return}
  var snap=x;snap.advance(Date())
  var items:[(String,String,Double)]=[]
  if snap.fullTime>1 && snap.feedTime>=snap.fullTime {items.append(("nest","Your nest is full. Collect the eggs when you visit.",snap.fullTime))}
  if snap.feedTime>1 {items.append(("feed","The trough is empty. Bring grain to keep eggs coming.",snap.feedTime))}
  var cal=Calendar(identifier:.iso8601);cal.timeZone = .current
  if let end=cal.dateInterval(of:.weekOfYear,for:Date())?.end {items.append(("fair","A new weekly fair is open in your farm.",end.timeIntervalSinceNow+1))}
  for (id,key,seconds) in items where seconds>1 {
   let a=UNMutableNotificationContent();a.title=pzL("Chicken Farm Idle: Coop");a.body=pzL(key);a.sound = .default
   do {try await c.add(UNNotificationRequest(identifier:id,content:a,trigger:UNTimeIntervalNotificationTrigger(timeInterval:max(2,seconds),repeats:false)))}
   catch {message=pzL("Reminders are unavailable. Your farm still works offline.")}
  }
 }
 func reset(){disable();x=pzSeed();storageNote=nil;try? FileManager.default.removeItem(at:file);try? FileManager.default.removeItem(at:file.appendingPathExtension("backup"));save()}
}

@main struct pzDawn:App {
 @StateObject private var q=pzNest()
 @Environment(\.scenePhase) private var phase
 var body:some Scene {WindowGroup {pzYard(q:q).tint(pzTone.moss).preferredColorScheme(.light).onChange(of:phase){_,p in if p == .active || p == .background {q.checkpoint()}}}}
}
