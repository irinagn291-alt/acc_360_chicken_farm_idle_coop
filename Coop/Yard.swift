import SwiftUI
import Combine

struct pzYard:View {
 @ObservedObject var q:pzNest
 @State private var page=0
 @State private var prefs=false
 @State private var erase=false
 @Environment(\.horizontalSizeClass) private var size
 private let timer=Timer.publish(every:1,on:.main,in:.common).autoconnect()
 var body:some View {
  NavigationStack {
   TabView(selection:$page){
    surface(0).tabItem{Label(pzL("Yard"),systemImage:"sun.max.fill")}.tag(0)
    surface(1).tabItem{Label(pzL("Barn"),systemImage:"shippingbox.fill")}.tag(1)
    surface(2).tabItem{Label(pzL("Market"),systemImage:"basket.fill")}.tag(2)
    surface(3).tabItem{Label(pzL("Grow"),systemImage:"leaf.fill")}.tag(3)
   }.navigationTitle(pzL(["Chicken Farm Idle: Coop","The grain barn","Farm market","Room to grow"][page]))
    .toolbar {ToolbarItem(placement:.topBarTrailing){Button {prefs=true} label:{Image(systemName:"slider.horizontal.3")}.accessibilityLabel(pzL("Farm settings")).accessibilityIdentifier("settings")}}
    .toolbarBackground(pzTone.cream,for:.navigationBar)
    .sheet(isPresented:$prefs){settings}
    .alert(pzL("Farm update"),isPresented:Binding(get:{q.message != nil},set:{if !$0 {q.message=nil}})){Button(pzL("OK")){q.message=nil}} message:{Text(q.message ?? "")}
  }.onReceive(timer){_ in q.pulse()}.onOpenURL {url in if url.host=="barn" {page=1} else if url.host=="market"{page=2}else{page=0}}
 }
 func surface(_ p:Int)->some View {
  ScrollView {
   VStack(alignment:.leading,spacing:20){
    HStack {Label(pzF("%d care days",q.x.effectiveStreak),systemImage:"flame.fill").foregroundStyle(pzTone.moss);Spacer();Label(q.x.coins.formatted(),systemImage:"circle.fill").foregroundStyle(pzTone.ink)}.font(.system(.subheadline,design:.rounded,weight:.semibold)).padding(.horizontal,4)
    if let note=q.storageNote {Text(note).font(.callout).padding().background(pzTone.sun.opacity(0.3),in:RoundedRectangle(cornerRadius:16))}
    switch p {case 0:yard;case 1:barn;case 2:market;default:grow}
   }.padding(20).frame(maxWidth:1100).frame(maxWidth:.infinity)
  }.background(pzTone.cream).accessibilityIdentifier("surface\(p)")
 }
 var yard:some View {
  VStack(alignment:.leading,spacing:20){
   HStack(alignment:.firstTextBaseline){Text(pzL("A little care.\nA happy flock.")).font(.system(size:size == .regular ? 38:30,weight:.bold,design:.rounded));Spacer();Text(pzL("YOUR FARM")).font(.caption.weight(.bold)).foregroundStyle(pzTone.moss)}.foregroundStyle(pzTone.ink)
   pzPasture(hens:q.x.hens,big:size == .regular).frame(height:size == .regular ? 390:260)
   ViewThatFits(in:.horizontal){
    HStack(spacing:12){metric("Hens","bird.fill","\(q.x.hens)/\(q.x.maxHens)");metric("In the nest","oval.fill","\(q.x.ready)/\(q.x.nestCap)");metric("Eggs in barn","basket.fill","\(q.x.eggs)")}
    VStack(spacing:10){metric("Hens","bird.fill","\(q.x.hens)/\(q.x.maxHens)");metric("In the nest","oval.fill","\(q.x.ready)/\(q.x.nestCap)");metric("Eggs in barn","basket.fill","\(q.x.eggs)")}
   }
   if size == .regular {HStack(alignment:.top,spacing:20){collect;feedPanel}}else{collect;feedPanel}
   pzPanel {VStack(alignment:.leading,spacing:12){
    Label(pzL("Today's care"),systemImage:"heart.fill").font(.headline).foregroundStyle(pzTone.moss)
    Text(q.x.cared.map{Calendar.current.isDateInToday($0)} == true ? pzL("Your flock has been cared for today."):pzL("Collect eggs or fill the trough to keep your care streak going.")).font(.subheadline)
    Text(pzF("%d eggs collected in all",q.x.gathered)).font(.caption).foregroundStyle(.secondary)
   }}
  }
 }
 func metric(_ k:String,_ icon:String,_ value:String)->some View {VStack(alignment:.leading,spacing:6){Image(systemName:icon).foregroundStyle(pzTone.moss);Text(value).font(.system(.title2,design:.rounded,weight:.bold)).monospacedDigit();Text(pzL(k)).font(.caption).foregroundStyle(.secondary)}.frame(maxWidth:.infinity,alignment:.leading).padding(16).background(.white,in:RoundedRectangle(cornerRadius:20)).accessibilityElement(children:.combine)}
 var collect:some View {pzPanel {VStack(alignment:.leading,spacing:14){
  HStack {Text(pzL("Nest check")).font(.title3.bold());Spacer();Image(systemName:"oval.fill").foregroundStyle(pzTone.peach)}
  ProgressView(value:q.x.nest,total:Double(q.x.nestCap)).tint(pzTone.grass)
  Text(q.x.trough<0.001 ? pzL("Production is paused until you add grain."):(q.x.ready>=q.x.nestCap ? pzL("The nest is full. Time to gather!"):pzF("Next egg in %d seconds",max(1,Int((ceil(q.x.nest+0.00001)-q.x.nest)/q.x.eggRate))))).font(.subheadline).foregroundStyle(.secondary)
  Button {q.act{_ = $0.collect(Date())}} label:{Label(pzF("Collect %d eggs",q.x.ready),systemImage:"basket.fill")}.buttonStyle(pzPress(pale:true)).disabled(q.x.ready==0).opacity(q.x.ready==0 ? 0.55:1).accessibilityIdentifier("collect")
 }}}
 var feedPanel:some View {pzPanel {VStack(alignment:.leading,spacing:14){
  HStack {Text(pzL("Feeding time")).font(.title3.bold());Spacer();Image(systemName:"leaf.fill").foregroundStyle(pzTone.grass)}
  HStack {Text(pzL("Grain in trough"));Spacer();Text("\(q.x.trough, specifier:"%.1f") / \(Int(q.x.troughCap))").monospacedDigit()}.font(.subheadline)
  ProgressView(value:q.x.trough,total:q.x.troughCap)
  Text(q.x.trough<0.001 ? pzL("The birds need grain. They will wait safely."):pzF("Feed lasts %d minutes",Int(ceil(q.x.feedTime/60)))).font(.subheadline).foregroundStyle(.secondary)
  Button {q.act{_ = $0.feed(Date())}} label:{Label(pzL("Fill the trough"),systemImage:"leaf.arrow.triangle.circlepath")}.buttonStyle(pzPress()).disabled(q.x.grain<0.01 || q.x.trough>=q.x.troughCap-0.01).accessibilityIdentifier("feed")
 }}}
 var barn:some View {VStack(alignment:.leading,spacing:20){
  Text(pzL("Keep the good things growing.")).font(.system(.title,design:.rounded,weight:.bold))
  HStack(spacing:12){metric("Grain reserve","leaf.fill","\(Int(q.x.grain))/\(Int(q.x.grainCap))");metric("Eggs in barn","basket.fill","\(q.x.eggs)")}
  feedPanel
  pzPanel {VStack(alignment:.leading,spacing:14){Label(pzL("A walk in the meadow"),systemImage:"sun.max.fill").font(.title3.bold());Text(pzL("Gather 10 grain for free every 30 minutes. A small harvest keeps your farm going, even with no coins.")).font(.subheadline).foregroundStyle(.secondary)
   if q.x.forageReady>Date(){HStack{Text(pzL("Ready in"));Text(q.x.forageReady,style:.timer).monospacedDigit()}.font(.subheadline)}
   Button {q.act{_ = $0.pick(Date())}}label:{Text(pzL("Gather 10 grain"))}.buttonStyle(pzPress(pale:true)).disabled(q.x.forageReady>Date() || q.x.grain>=q.x.grainCap).accessibilityIdentifier("forage")
  }}
  pzPanel {VStack(alignment:.leading,spacing:10){Text(pzL("Farm rhythm")).font(.headline);Text(pzL("Each hen uses 1 grain every 10 minutes. Eggs grow only while the trough has grain. A full nest pauses egg storage; feeding still continues.")).font(.subheadline).foregroundStyle(.secondary);Text(pzF("Each hen lays an egg every %d seconds",Int(q.x.interval))).font(.subheadline);Text(pzL("Progress uses this device's clock. Moving the clock back pauses progress until the saved time is reached.")).font(.caption).foregroundStyle(.secondary)}}
 }}
 var market:some View {VStack(alignment:.leading,spacing:20){
  Text(pzL("From your farm, with love.")).font(.system(.title,design:.rounded,weight:.bold))
  Text(pzL("All coins are earned here by selling eggs and filling orders. Everything is free to play.")).font(.subheadline).foregroundStyle(.secondary)
  pzPanel {VStack(alignment:.leading,spacing:14){Label(pzL("Farm stall"),systemImage:"basket.fill").font(.title3.bold());Text(pzL("One egg earns 3 coins.")).foregroundStyle(.secondary);Button{q.act{_ = $0.sell($0.eggs,Date())}}label:{Text(pzF("Sell %d eggs",q.x.eggs))}.buttonStyle(pzPress(pale:true)).disabled(q.x.eggs==0).accessibilityIdentifier("sell")}}
  pzPanel {VStack(alignment:.leading,spacing:14){Text(pzL("Stock up")).font(.title3.bold());Text(pzL("20 grain · 12 coins")).foregroundStyle(.secondary);Button{q.act{_ = $0.buyFeed(Date())}}label:{Text(pzL("Buy grain"))}.buttonStyle(pzPress()).disabled(q.x.coins<12 || q.x.grain+20>q.x.grainCap).accessibilityIdentifier("buyGrain");Text(pzL("Make space in the barn before buying more grain.")).font(.caption).foregroundStyle(.secondary)}}
  Text(pzL("Neighbor orders")).font(.system(.title2,design:.rounded,weight:.bold))
  ForEach(0..<3){i in pzPanel {VStack(alignment:.leading,spacing:12){HStack {Image(systemName:["carrot.fill","birthday.cake.fill","cup.and.saucer.fill"][i]).font(.title2).foregroundStyle(pzTone.peach);VStack(alignment:.leading){Text(pzL(["The garden kitchen","The village baker","The breakfast table"][i])).font(.headline);Text(pzF("Needs %d eggs",q.x.amount(i))).font(.subheadline).foregroundStyle(.secondary)};Spacer();Label("\(q.x.pay(i))",systemImage:"circle.fill").font(.headline).foregroundStyle(pzTone.moss)}
   Button{q.act{_ = $0.deliver(i,Date())}}label:{Text(pzL("Deliver eggs"))}.buttonStyle(pzPress()).disabled(q.x.eggs<q.x.amount(i)).accessibilityIdentifier("order\(i)")
  }}}
  fair
 }}
 var fair:some View {pzPanel {VStack(alignment:.leading,spacing:16){
  Label(pzL("The weekly fair"),systemImage:"flag.2.crossed.fill").font(.system(.title2,design:.rounded,weight:.bold)).foregroundStyle(pzTone.moss)
  Text(pzL("A fresh set of tasks every Monday. Finish all three for 120 farm coins.")).font(.subheadline).foregroundStyle(.secondary)
  goal("Collect eggs",q.x.weekEggs,q.x.fairGoal);goal("Fill neighbor orders",q.x.weekOrders,4);goal("Add grain to the trough",Int(q.x.weekFeed),30)
  Button{q.act{_ = $0.claim(Date())}}label:{Text(pzL(q.x.claimed ? "Fair completed":"Collect 120 coins"))}.buttonStyle(pzPress(pale:true)).disabled(!q.x.fairDone || q.x.claimed).accessibilityIdentifier("fairClaim")
 }}}
 func goal(_ t:String,_ n:Int,_ cap:Int)->some View {VStack(alignment:.leading,spacing:6){HStack{Text(pzL(t));Spacer();Text("\(min(n,cap))/\(cap)").monospacedDigit()}.font(.subheadline);ProgressView(value:Double(min(n,cap)),total:Double(cap))}}
 var grow:some View {VStack(alignment:.leading,spacing:20){
  Text(pzL("A cozy home,\none step at a time.")).font(.system(.title,design:.rounded,weight:.bold))
  pzPanel {VStack(alignment:.leading,spacing:14){HStack{pzBird().scaleEffect(0.8).frame(width:70,height:65);VStack(alignment:.leading){Text(pzL("Welcome a hen")).font(.title3.bold());Text(pzF("Space for %d hens",q.x.maxHens)).font(.subheadline).foregroundStyle(.secondary)}};Button{q.act{_ = $0.buyHen(Date())}}label:{Text(pzF("Add hen · %d coins",q.x.henPrice))}.buttonStyle(pzPress(pale:true)).disabled(q.x.hens>=q.x.maxHens || q.x.coins<q.x.henPrice).accessibilityIdentifier("hen");if q.x.hens>=q.x.maxHens {Text(pzL("Expand the coop to welcome more hens.")).font(.caption)}}}
  ForEach(0..<3){i in pzPanel {VStack(alignment:.leading,spacing:14){
   HStack{Image(systemName:["house.fill","oval.fill","shippingbox.fill"][i]).font(.title2).foregroundStyle(pzTone.moss);Text(pzL(["Coop expansion","Soft nesting beds","Bigger grain store"][i])).font(.title3.bold());Spacer();Text("\(q.x.level(i))/4").font(.subheadline.monospacedDigit())}
   Text(pzL(["Each level adds space for 3 hens and 24 eggs in the nest.","Each level adds a quarter of the original laying speed.","Each level adds 80 grain to the barn and 12 to the trough."][i])).font(.subheadline).foregroundStyle(.secondary)
   if !q.x.unlocked(i){Label(pzL("Requires the first coop expansion"),systemImage:"lock.fill").font(.caption)}
   Button{q.act{_ = $0.improve(i,Date())}}label:{Text(q.x.level(i)==4 ? pzL("Fully grown"):pzF("Improve · %d coins",q.x.price(i)))}.buttonStyle(pzPress()).disabled(!q.x.unlocked(i) || q.x.level(i)==4 || q.x.coins<q.x.price(i)).accessibilityIdentifier("upgrade\(i)")
  }}}
 }}
 var settings:some View {NavigationStack {Form {
  Section(pzL("Gentle reminders")){
   Text(pzL("Choose reminders for a full nest, an empty trough, and the start of the weekly fair. Your farm works the same if you decline.")).font(.subheadline)
   LabeledContent(pzL("Device permission"),value:q.permission)
   if q.alerts {Button(pzL("Turn reminders off")){q.disable()}}else{Button(pzL("Enable reminders")){Task{await q.request()}}.accessibilityIdentifier("enableReminders")}
   Text(pzL("If permission was declined, you can change it in the device's notification settings.")).font(.caption)
  }
  Section(pzL("Your farm, your device")){
   Text(pzL("No account, purchases, advertising, analytics, or network connection. Farm progress is saved on this device and shared only with your farm widgets. Removing the app removes its farm.")).font(.subheadline)
   Text(pzL("Your starter supplies are 3 hens, 80 farm coins, 48 stored grain, and 12 grain in the trough.")).font(.subheadline)
   Text(pzL("Add a Chicken Farm Idle: Coop widget from your Home Screen or Lock Screen. Widget refresh timing is controlled by the system.")).font(.subheadline)
  }
  Section {Button(pzL("Start a new farm"),role:.destructive){erase=true}.accessibilityIdentifier("reset")}
 }.navigationTitle(pzL("Farm settings")).toolbar{ToolbarItem(placement:.confirmationAction){Button(pzL("Done")){prefs=false}}}
 .confirmationDialog(pzL("Replace this farm?"),isPresented:$erase,titleVisibility:.visible){Button(pzL("Erase farm and restart"),role:.destructive){q.reset()}}message:{Text(pzL("All hens, coins, and progress on this device will be replaced with starter supplies."))}
 }}
}
