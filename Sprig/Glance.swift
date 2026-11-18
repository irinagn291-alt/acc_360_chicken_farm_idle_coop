import WidgetKit
import SwiftUI

struct pzMoment:TimelineEntry {var date:Date;var s:pzSeed;var started:Bool}
struct pzClock:TimelineProvider {
 func placeholder(in context:Context)->pzMoment {pzMoment(date:Date(),s:pzSeed(),started:false)}
 func getSnapshot(in context:Context,completion:@escaping(pzMoment)->Void){completion(read(Date()))}
 func read(_ d:Date)->pzMoment {
  let bytes=UserDefaults(suiteName:pzGroup)?.data(forKey:"flock-snapshot")
  var x=bytes.flatMap{try? JSONDecoder().decode(pzSeed.self,from:$0)}
  if let a=x,!a.valid(){x=nil}
  let started=x != nil;var s=x ?? pzSeed(d);s.advance(d);return pzMoment(date:d,s:s,started:started)
 }
 func getTimeline(in context:Context,completion:@escaping(Timeline<pzMoment>)->Void){
  let now=Date();let entries=(0..<49).map{read(now.addingTimeInterval(Double($0)*300))}
  completion(Timeline(entries:entries,policy:.after(now.addingTimeInterval(3600))))
 }
}
struct pzGlance:View {
 var e:pzMoment
 var renderFamily:WidgetFamily?=nil
 @Environment(\.widgetFamily) private var family
 var body:some View {
  Group {
   if !e.started {VStack(alignment:.leading,spacing:8){Image(systemName:"bird.fill");Text(pzL("Chicken Farm Idle: Coop")).font(.headline);Text(pzL("Open your farm to begin.")).font(.caption)}}
   else {switch renderFamily ?? family {
   case .accessoryInline: Text(pzF("Coop waiting: %d h",hours))
   case .accessoryCircular: Gauge(value:e.s.nest,in:0...Double(e.s.nestCap)){Image(systemName:"oval.fill")} currentValueLabel:{Text("\(e.s.ready)")}.gaugeStyle(.accessoryCircular)
   case .accessoryRectangular: VStack(alignment:.leading){Label(pzF("Coop waiting: %d h",hours),systemImage:"bird.fill").font(.caption.bold()).lineLimit(2);Text(pzF("%d eggs ready",e.s.ready)).font(.caption);pzLine(a:e.s.nest,b:Double(e.s.nestCap))}
   case .systemSmall: VStack(alignment:.leading,spacing:6){Image(systemName:"flame.fill").font(.title2).foregroundStyle(pzTone.peach);Spacer();Text("\(e.s.effectiveStreak)").font(.system(size:46,weight:.bold,design:.rounded));Text(pzL("Care streak")).font(.headline);Text(pzF("%d eggs ready",e.s.ready)).font(.caption).foregroundStyle(.secondary)}.frame(maxWidth:.infinity,alignment:.leading)
   case .systemMedium: HStack(spacing:18){VStack(alignment:.leading,spacing:8){Label(pzL("Your coop is waiting"),systemImage:"bird.fill").font(.headline);Text(pzF("%d eggs ready",e.s.ready)).font(.system(.title2,design:.rounded,weight:.bold));Text(pzF("%d eggs collected in all",e.s.gathered)).font(.caption);pzLine(a:e.s.nest,b:Double(e.s.nestCap))};pzBird().scaleEffect(0.85).frame(width:74)}
   default: VStack(alignment:.leading,spacing:12){HStack{Text(pzL("Your farmyard")).font(.system(.title2,design:.rounded,weight:.bold));Spacer();Label("\(e.s.hens)",systemImage:"bird.fill")};pzPasture(hens:e.s.hens).frame(height:116);HStack{Label(pzF("%d eggs ready",e.s.ready),systemImage:"basket.fill");Spacer();Label("\(Int(e.s.grain))",systemImage:"leaf.fill")}.font(.subheadline.bold());Divider();Text(pzL("Neighbor orders")).font(.headline);ForEach(0..<3){i in HStack{Text(pzL(["The garden kitchen","The village baker","The breakfast table"][i])).lineLimit(1);Spacer();Text(pzF("Needs %d eggs",e.s.amount(i)))}.font(.caption)}
   }}}
  }.foregroundStyle(pzTone.moss).tint(pzTone.grass).containerBackground(pzTone.cream,for:.widget).widgetURL(URL(string:"meadowquill://yard"))
 }
 var hours:Int {max(0,Int(e.date.timeIntervalSince(e.s.collected ?? e.s.began)/3600))}
}
#if !COOP_UI_TESTS
@main struct pzWindow:Widget {
 var body:some WidgetConfiguration {StaticConfiguration(kind:"meadowquill-glance",provider:pzClock()){pzGlance(e:$0)}.configurationDisplayName(pzL("Chicken Farm Idle: Coop")).description(pzL("Your care streak, eggs, grain, and neighbor orders.")).supportedFamilies([.systemSmall,.systemMedium,.systemLarge,.accessoryInline,.accessoryCircular,.accessoryRectangular])}
}

#endif

struct pzLine:View {var a:Double;var b:Double;var body:some View {GeometryReader{g in ZStack(alignment:.leading){Capsule().fill(pzTone.grass.opacity(0.2));Capsule().fill(pzTone.grass).frame(width:g.size.width*min(1,max(0,a/b)))}}.frame(height:4)}}
