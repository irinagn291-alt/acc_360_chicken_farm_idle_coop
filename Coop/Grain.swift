import Foundation

let pzGroup = "group.net.meadowquill.coop731"
func pzL(_ k:String) -> String { NSLocalizedString(k, comment: "") }
func pzF(_ k:String,_ n:Int) -> String { String(format:pzL(k),n) }

struct pzSeed: Codable, Equatable {
 var v=1, hens=3, coins=80, eggs=0, gathered=0, sold=0, deliveries=0
 var nest=0.0, grain=48.0, trough=12.0
 var coop=0, bedding=0, silo=0
 var began:Date, tick:Date, collected:Date?, cared:Date?, forage:Date?
 var streak=0, week:String, weekEggs=0, weekOrders=0, claimed=false
 var weekFeed=0.0
 var order:[Int]=[0,0,0]
 init(_ d:Date=Date()) { began=d; tick=d; week=Self.wk(d) }
 static func wk(_ d:Date)->String { var c=Calendar(identifier:.iso8601); c.timeZone = .current; let x=c.dateComponents([.yearForWeekOfYear,.weekOfYear], from:d); return "\(x.yearForWeekOfYear ?? 0)-\(x.weekOfYear ?? 0)" }
 var maxHens:Int { 4+coop*3 }
 var nestCap:Int { 24+coop*24 }
 var grainCap:Double { Double(80+silo*80) }
 var troughCap:Double { Double(12+silo*12) }
 var interval:Double { 120.0/(1+Double(bedding)*0.25) }
 var feedRate:Double { Double(hens)/600 }
 var eggRate:Double { Double(hens)/interval }
 var ready:Int { Int(nest.rounded(.down)) }
 var feedTime:TimeInterval { trough/feedRate }
 var fullTime:TimeInterval { max(0,Double(nestCap)-nest)/eggRate }
 var fairGoal:Int { 60 + (abs(Int(week.split(separator:"-").last ?? "0") ?? 0)%3)*12 }
 var fairDone:Bool { weekEggs >= fairGoal && weekOrders >= 4 && weekFeed >= 30 }
 var effectiveStreak:Int { guard let d=cared else{return 0}; let c=Calendar.current; let gap=c.dateComponents([.day], from:c.startOfDay(for:d), to:c.startOfDay(for:tick)).day ?? 0; return gap <= 1 ? streak:0 }
 mutating func advance(_ d:Date) {
  guard d > tick else {return}
  let seconds=d.timeIntervalSince(tick), active=min(seconds,feedTime)
  nest=min(Double(nestCap),nest+active*eggRate)
  trough=max(0,trough-active*feedRate); tick=d
  if week != Self.wk(d) { week=Self.wk(d); weekEggs=0; weekOrders=0; weekFeed=0; claimed=false }
 }
 mutating func care(_ d:Date) {
  let c=Calendar.current
  if let old=cared, c.isDate(old,inSameDayAs:d) {return}
  if let old=cared, c.dateComponents([.day],from:c.startOfDay(for:old),to:c.startOfDay(for:d)).day == 1 {streak+=1} else {streak=1}
  cared=d
 }
 @discardableResult mutating func collect(_ d:Date)->Int {
  advance(d); let n=ready; guard n>0 else{return 0}; nest-=Double(n); eggs+=n; gathered+=n; weekEggs+=n; collected=d; care(d); return n
 }
 @discardableResult mutating func feed(_ d:Date)->Int {
  advance(d); let n=min(grain,max(0,troughCap-trough)); guard n>=0.01 else{return 0}
  grain-=n; trough+=n; weekFeed+=n; care(d); return Int(n.rounded())
 }
 @discardableResult mutating func sell(_ n:Int,_ d:Date)->Bool {
  advance(d); guard n>0 && eggs>=n else{return false}; eggs-=n; sold+=n; coins+=n*3; return true
 }
 @discardableResult mutating func buyFeed(_ d:Date)->Bool {advance(d); guard coins>=12 && grain+20<=grainCap+0.001 else{return false}; coins-=12; grain+=20;return true}
 var henPrice:Int { 60+(hens-3)*35 }
 @discardableResult mutating func buyHen(_ d:Date)->Bool {advance(d);guard hens<maxHens && coins>=henPrice else{return false}; coins-=henPrice;hens+=1;return true}
 func amount(_ i:Int)->Int { [6,10,14][i]+order[i]%4*2 }
 func pay(_ i:Int)->Int { amount(i)*4+4 }
 @discardableResult mutating func deliver(_ i:Int,_ d:Date)->Bool {
  advance(d);guard (0..<3).contains(i) else{return false}; let n=amount(i); guard eggs>=n else{return false}; eggs-=n; coins+=pay(i); deliveries+=1;weekOrders+=1;order[i]+=1;return true
 }
 func level(_ i:Int)->Int { i==0 ? coop:(i==1 ? bedding:silo) }
 func price(_ i:Int)->Int { [90,75,65][i]*(level(i)+1) }
 func unlocked(_ i:Int)->Bool {i==0 || coop>0}
 @discardableResult mutating func improve(_ i:Int,_ d:Date)->Bool {
  advance(d);guard (0..<3).contains(i),unlocked(i),level(i)<4,coins>=price(i) else{return false}; coins-=price(i)
  switch i { case 0:coop+=1;case 1:bedding+=1;default:silo+=1 };return true
 }
 var forageReady:Date { forage?.addingTimeInterval(1800) ?? .distantPast }
 @discardableResult mutating func pick(_ d:Date)->Bool {advance(d);guard d>=forageReady,grain<grainCap else{return false};grain=min(grainCap,grain+10);forage=d;care(d);return true}
 @discardableResult mutating func claim(_ d:Date)->Bool {advance(d);guard fairDone && !claimed else{return false};coins+=120;claimed=true;return true}
 func valid()->Bool {v==1 && (3...16).contains(hens) && (0...4).contains(coop) && (0...4).contains(bedding) && (0...4).contains(silo) && coins>=0 && eggs>=0 && nest.isFinite && grain.isFinite && trough.isFinite && nest>=0 && nest<=Double(nestCap)+0.01 && grain>=0 && grain<=grainCap+0.01 && trough>=0 && trough<=troughCap+0.01 && order.count==3 && order.allSatisfy{$0>=0} && hens<=maxHens && tick.timeIntervalSince1970.isFinite }
}

#if COOP_VERIFY
@main struct pzProof {
 static func main() throws {
  let d=Date(timeIntervalSince1970:1800000000)
  var a=pzSeed(d);a.advance(d.addingTimeInterval(120));assert(a.ready==3);assert(abs(a.trough-11.4)<0.0001)
  var b=pzSeed(d);b.advance(d.addingTimeInterval(2400));assert(b.ready==24 && b.trough==0)
  let n=b.nest;b.advance(d.addingTimeInterval(999999));assert(b.nest==n)
  let t=b.tick;b.advance(d);assert(b.tick==t && b.nest==n)
  assert(b.collect(t)==24 && b.eggs==24 && b.streak==1);assert(b.collect(t)==0)
  assert(b.sell(24,t) && b.coins==152);assert(!b.sell(1,t));assert(!b.sell(-1,t))
  var c=pzSeed(d);c.eggs=30;assert(c.deliver(0,d));assert(c.eggs==24 && c.coins==108 && c.amount(0)==8)
  assert(!c.improve(1,d));assert(c.improve(0,d));assert(c.coop==1 && c.coins==18)
  c.coins=1000;assert(c.improve(1,d));assert(c.interval==96)
  var e=pzSeed(d);e.grain=0;e.trough=0;assert(e.pick(d));assert(!e.pick(d));assert(e.feed(d)==10);assert(e.streak==1)
  assert(e.pick(d.addingTimeInterval(1800)));e.care(d.addingTimeInterval(86400));assert(e.streak==2);e.care(d.addingTimeInterval(4*86400));assert(e.streak==1)
  var f=pzSeed(d);f.weekEggs=f.fairGoal;f.weekOrders=4;f.weekFeed=30;assert(f.claim(d));assert(!f.claim(d));f.advance(d.addingTimeInterval(8*86400));assert(f.weekEggs==0 && !f.claimed)
  let data=try JSONEncoder().encode(c);let decoded=try JSONDecoder().decode(pzSeed.self,from:data);assert(decoded==c)
  assert(c.valid());c.nest = .nan;assert(!c.valid())
  var h=pzSeed(d);h.coins=0;h.grain=0;h.trough=0;assert(h.pick(d));assert(h.feed(d)>0);h.advance(d.addingTimeInterval(120));assert(h.collect(h.tick)>0);assert(h.sell(h.eggs,h.tick));assert(h.coins>0)
  print("PASS: production, feed exhaustion, capacity, clock rollback, collection, economy, orders, upgrade dependencies, forage recovery, streak, fair rollover, persistence, validation")
 }
}
#endif
