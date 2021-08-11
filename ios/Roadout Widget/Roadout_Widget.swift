//
//  Roadout_Widget.swift
//  Roadout Widget
//
//  Created by David Retegan on 10.08.2021.
//

import WidgetKit
import SwiftUI

struct RoadoutEntry: TimelineEntry {
    let date = Date()
    var spots: String
}

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> RoadoutEntry {
        return Entry(spots: "9")
    }
    
    
    func getSnapshot(in context: Context, completion: @escaping (RoadoutEntry) -> Void) {
        completion(Entry(spots: "9"))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RoadoutEntry>) -> Void) {
        let entry = Entry(spots: "9")
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}

struct PlaceholderView: View {
    var body: some View {
        RoadoutView(date: Date(), spots: "9")
    }
}
struct WidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        RoadoutView(date: Date(), spots: "9")
    }
}

struct RoadoutView: View {
    
    let date: Date
    var spots: String

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            HStack {
                VStack(alignment: .leading) {
                    Text("9")
                        .fontWeight(.medium)
                        .font(.custom("Karla", size: 35))
                        .foregroundColor(Color("AccentColor"))
                        .multilineTextAlignment(.leading)
                        .padding([.top, .leading], 14.0)
                    Text("Free Spots")
                        .fontWeight(.medium)
                        .font(.system(size: 15))
                        .foregroundColor(Color("AccentColor"))
                        .padding(.leading, 13.0)
                    Text("Old Town")
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                        .padding(EdgeInsets(top: -4.0, leading: 13.0, bottom: 0.0, trailing: 0.0))
                    Spacer()
                    ZStack(alignment: .bottomTrailing) {
                        HStack() {
                            Spacer()
                            Image("YellowThing")
                                .resizable()
                                .frame(width: 31.0, height: 36.0)
                        }
                    }
                    .padding([.leading, .bottom], 10.0)
                }
                Spacer()
            }
             
        case .systemMedium:
            HStack() {
                HStack {
                    VStack(alignment: .leading) {
                        Text("9")
                            .fontWeight(.medium)
                            .font(.custom("Karla", size: 35))
                            .foregroundColor(Color("AccentColor"))
                            .multilineTextAlignment(.leading)
                            .padding([.top, .leading], 14.0)
                        Text("Free Spots")
                            .fontWeight(.medium)
                            .font(.system(size: 15))
                            .foregroundColor(Color("AccentColor"))
                            .padding(.leading, 13.0)
                        Text("Location 1")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: -4.0, leading: 13.0, bottom: 0.0, trailing: 0.0))
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                            HStack() {
                                Spacer()
                                Image("YellowThing")
                                    .resizable()
                                    .frame(width: 31.0, height: 36.0)
                            }
                        }
                        .padding([.leading, .bottom], 10.0)
                    }
                    Spacer()
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("14")
                            .fontWeight(.medium)
                            .font(.custom("Karla", size: 35))
                            .foregroundColor(Color("Dark Yellow"))
                            .multilineTextAlignment(.leading)
                            .padding(EdgeInsets(top: 16.0, leading: 8.0, bottom: 0.0, trailing: 0.0))
                        Text("Free Spots")
                            .fontWeight(.medium)
                            .font(.system(size: 15))
                            .foregroundColor(Color("Dark Yellow"))
                            .padding(.leading, 13.0)
                        Text("Location 2")
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: -4.0, leading: 13.0, bottom: 0.0, trailing: 0.0))
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                            HStack() {
                                Spacer()
                                Image("BrownThing")
                                    .resizable()
                                    .frame(width: 31.0, height: 39.0)
                            }
                        }
                        .padding([.leading, .bottom], 12.0)
                    }
                    Spacer()
                }
                .background(Color("Greyish"))
                .cornerRadius(24)
            }
        default:
            VStack(alignment: .leading, spacing: 30) {
    
            }
            .frame(width: 200, alignment: .leading)
        }
    }
    
}
@main
struct RoadoutWidget: Widget {
    private let kind = "Roadout_Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Roadout Watch")
        .description("Have real-time free spots at certain locations right on your homescreen")
    }
}
