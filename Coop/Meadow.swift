import SwiftUI

enum pzTone {
 static let cream=Color(red:0.98,green:0.97,blue:0.91), moss=Color(red:0.23,green:0.34,blue:0.15), grass=Color(red:0.486,green:0.71,blue:0.094), sun=Color(red:1,green:0.831,blue:0), ink=Color(red:0.169,green:0.169,blue:0.169), peach=Color(red:1,green:0.55,blue:0.26)
}
struct pzBird:View {
 var flip=false
 var body:some View {
  ZStack {
   Capsule().fill(pzTone.peach).frame(width:5,height:22).offset(x:-9,y:27)
   Capsule().fill(pzTone.peach).frame(width:5,height:22).offset(x:9,y:27)
   Ellipse().fill(Color(red:0.89,green:0.86,blue:0.71)).frame(width:70,height:12).offset(y:36)
   Ellipse().fill(.white).frame(width:62,height:48).rotationEffect(.degrees(-10)).offset(x:-6,y:7)
   Ellipse().fill(Color(red:0.95,green:0.94,blue:0.85)).frame(width:33,height:25).rotationEffect(.degrees(-25)).offset(x:-15,y:9)
   Ellipse().fill(.white).frame(width:39,height:40).offset(x:14,y:-14)
   ForEach(0..<3) {i in Circle().fill(Color(red:0.83,green:0.26,blue:0.15)).frame(width:13).offset(x:Double(i)*8+4,y:-34-Double(i%2)*4)}
   pzTriangle().fill(pzTone.peach).frame(width:16,height:12).rotationEffect(.degrees(90)).offset(x:36,y:-11)
   Circle().fill(pzTone.ink).frame(width:5).offset(x:23,y:-19)
   Circle().fill(pzTone.peach.opacity(0.25)).frame(width:10).offset(x:23,y:-9)
  }.frame(width:92,height:82).scaleEffect(x:flip ? -1:1,y:1).accessibilityHidden(true)
 }
}
struct pzTriangle:Shape {func path(in r:CGRect)->Path {Path {p in p.move(to:CGPoint(x:r.midX,y:r.minY));p.addLine(to:CGPoint(x:r.maxX,y:r.maxY));p.addLine(to:CGPoint(x:r.minX,y:r.maxY));p.closeSubpath()}}}
struct pzPasture:View {
 var hens:Int;var big=false
 var body:some View {
  GeometryReader {g in
   let w=g.size.width;let h=g.size.height
   ZStack {
    LinearGradient(colors:[Color(red:0.88,green:0.94,blue:0.75),Color(red:0.98,green:0.93,blue:0.62)],startPoint:.top,endPoint:.bottom)
    Circle().fill(pzTone.sun).frame(width:65,height:65).position(x:w*0.83,y:h*0.19)
    Ellipse().fill(Color(red:0.65,green:0.78,blue:0.34)).frame(width:w*1.6,height:h*0.65).position(x:w*0.2,y:h*0.8)
    Ellipse().fill(pzTone.grass).frame(width:w*1.9,height:h*0.8).position(x:w*0.8,y:h*1.01)
    ForEach(0..<12){i in
     RoundedRectangle(cornerRadius:3).fill(Color(red:0.98,green:0.92,blue:0.69)).frame(width:8,height:45).position(x:Double(i)*w/10-8,y:h*0.59)
    }
    Rectangle().fill(Color(red:0.98,green:0.92,blue:0.69)).frame(height:6).position(x:w/2,y:h*0.6)
    ZStack {
     RoundedRectangle(cornerRadius:6).fill(Color(red:0.65,green:0.35,blue:0.16)).frame(width:128,height:91).offset(y:19)
     ForEach(0..<6){i in Rectangle().fill(Color.white.opacity(0.1)).frame(width:2,height:85).offset(x:Double(i)*20-50,y:19)}
     RoundedRectangle(cornerRadius:25).fill(Color(red:0.23,green:0.26,blue:0.12)).frame(width:38,height:55).offset(y:37)
     RoundedRectangle(cornerRadius:4).fill(Color(red:0.99,green:0.88,blue:0.47)).frame(width:27,height:25).offset(x:36,y:5)
     Rectangle().fill(Color(red:0.65,green:0.35,blue:0.16)).frame(width:3,height:23).offset(x:36,y:5)
     pzTriangle().fill(pzTone.sun).frame(width:160,height:72).offset(y:-53)
     RoundedRectangle(cornerRadius:4).fill(pzTone.peach).frame(width:164,height:8).offset(y:-17)
     RoundedRectangle(cornerRadius:4).fill(Color(red:0.81,green:0.60,blue:0.31)).frame(width:40,height:35).rotationEffect(.degrees(15)).offset(y:80)
    }.scaleEffect(min(big ? 1.45:1.0,h/220)).position(x:w*0.36,y:h*0.48)
    ForEach(0..<min(hens,big ? 12:6),id:\.self){i in
     pzBird(flip:i%2==1).scaleEffect(h<170 ? 0.5:(big ? 0.9:0.72)).position(x:w*(0.55+Double(i%3)*0.13),y:h*((h<170 ? 0.65:0.69)+Double(i/3)*(h<170 ? 0.16:0.18)))
    }
    ForEach(0..<10){i in
     Image(systemName:"sparkle").font(.system(size:8)).foregroundStyle(Color(red:0.99,green:0.92,blue:0.60)).position(x:Double((i*67+25)%Int(max(1,w))),y:h*(0.75+Double(i%3)*0.09))
    }
   }.clipShape(RoundedRectangle(cornerRadius:28))
  }.accessibilityElement(children:.ignore).accessibilityLabel(pzF("%d hens in your farmyard",hens))
 }
}
struct pzPanel<Z:View>:View { @ViewBuilder var content:Z;var body:some View {content.padding(20).frame(maxWidth:.infinity,alignment:.leading).background(.white,in:RoundedRectangle(cornerRadius:24)).overlay(RoundedRectangle(cornerRadius:24).stroke(pzTone.moss.opacity(0.07)))}}
struct pzPress:ButtonStyle {var pale=false;func makeBody(configuration:Configuration)->some View {configuration.label.font(.system(.headline,design:.rounded)).padding(.vertical,15).frame(maxWidth:.infinity).background(pale ? pzTone.sun:pzTone.moss,in:RoundedRectangle(cornerRadius:16)).foregroundStyle(pale ? pzTone.ink:.white).opacity(configuration.isPressed ? 0.65:1)}}
