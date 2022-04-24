//
//  SystemImages.swift
//  GPKit
//
//  Created by sn99 on 28/03/22.
//

import Foundation
import SwiftUI


public enum SystemImages : String {
    
    case applelogo = "applelogo"
    case xmark_circle = "xmark.circle"
    case xmark_circle_fill = "xmark.circle.fill"
    case square_share = "square.and.arrow.up"
    case square_download = "square.and.arrow.down"
    case upload_icloud = "icloud.and.arrow.up"
    case upload_icloud_fill = "icloud.and.arrow.up.fill"
    case gearshape_setting = "gearshape"
    case gearshape_setting_fill = "gearshape.fill"
    case house = "house"
    case house_fill = "house.fill"
    case gear_setting = "gear"
    case gear_circle_setting = "gear.circle"
    case gear_circle_fill_setting = "gear.circle.fill"
    
    case speaker_off = "speaker.slash"
    case speaker_off_fill = "speaker.slash.fill"
    case speaker_on = "speaker.wave.3"
    case speaker_on_fill = "speaker.wave.3.fill"
    case bell = "bell"
    case bell_fill = "bell.fill"
    case camera = "camera"
    case camera_fill = "camera.fill"
    case person = "person"
    case person_fill = "person.fill"
    case person_circle = "person.circle"
    case person_circle_fill = "person.circle.fill"
    case eye_visible = "eye"
    case eye_hide = "eye.slash"
    
    // Text Formatting
    case signature = "signature"
    
    // Media
    case play = "play"
    case play_fill = "play.fill"
    case pause = "pause"
    case pause_fill = "pause.fill"
    case stop = "stop"
    case stop_fill = "stop.fill"
    case backward_end = "backward.end"
    case backward_end_fill = "backward.end.fill"
    case forward_end = "forward.end"
    case forward_end_fill = "forward.end.fill"
    case mic = "mic"
    case mic_fill = "mic.fill"
    case mic_slash = "mic.slash"
    
    // Time
    case clock = "clock"
    case clock_fill = "clock.fill"
    
    // Arrows
    case chevron_left = "chevron.left"
    case chevron_left_circle = "chevron.left.circle"
    case chevron_left_circle_fill = "chevron.left.circle.fill"
    case chevron_left_square = "chevron.left.square"
    case chevron_left_square_fill = "chevron.left.square.fill"
    case chevron_right = "chevron.right"
    case chevron_right_circle = "chevron.right.circle"
    case chevron_right_square = "chevron.right.square"
    case chevron_right_circle_fill = "chevron.right.circle.fill"
    case chevron_right_square_fill = "chevron.right.square.fill"
    case chevron_left_2 = "chevron.left.2"
    case chevron_right_2 = "chevron.right.2"
    case chevron_up = "chevron.up"
    case chevron_down = "chevron.down"
    case arrow_left = "arrow.left"
    case arrow_right = "arrow.right"
    case arrow_up = "arrow.up"
    case arrow_down = "arrow.down"
    case arrow_clockwise = "arrow.clockwise"
    case arrow_counterclockwise = "arrow.counterclockwise"
    case arrow_triangle_2_circlepath = "arrow.triangle.2.circlepath"
    case goforward = "goforward"
    case gobackward = "gobackward"
    
    case trash = "trash"
    case trash_circle = "trash.circle"
    case trash_circle_fill = "trash.circle.fill"
    case doc = "doc"
    case doc_fill = "doc.fill"
    case calendar = "calendar"
    case paperclip = "paperclip"
    case link = "link"
    case power = "power"
    case power_circle_fill = "power.circle.fill"
    case magnifyingglass = "magnifyingglass"
    case magnifyingglass_circle_fill = "magnifyingglass.circle.fill"
    case star = "star"
    case star_fill = "star.fill"
    case star_circle = "star.circle"
    case star_circle_fill = "star.circle.fill"
    case location_fill = "location.fill"
    case location_circle = "location.circle"
    case message = "message"
    case message_fill = "message.fill"
    case bubble_right = "bubble.right"
    case bubble_right_fill = "bubble.right.fill"
    case phone = "phone"
    case phone_fill = "phone.fill"
    case video = "video"
    case video_fill = "video.fill"
    case envelope = "envelope"
    case envelope_fill = "envelope.fill"
    case ellipsis = "ellipsis"
    case ellipsis_circle = "ellipsis.circle"
    case ellipsis_circle_fill = "ellipsis.circle.fill"
    case creditcard = "creditcard"
    case creditcard_fill = "creditcard.fill"
    case lock = "lock"
    case lock_fill = "lock.fill"
    case lock_circle = "lock.circle"
    case lock_circle_fill = "lock.circle.fill"
    case lock_open = "lock.open"
    case lock_open_fill = "lock.open.fill"
    case lock_slash = "lock.slash"
    case lock_slash_fill = "lock.slash.fill"
    case mappin_and_ellipse = "mappin.and.ellipse"
    case safari = "safari"
    
    
    case qrcode = "qrcode"
    case barcode = "barcode"
    case viewfinder = "viewfinder"
    case faceid = "faceid"
    case photo = "photo"
    case photo_fill = "photo.fill"
    case touchid = "touchid"
    case app_badge = "app.badge"
    

    
}


public extension Image {
    
     static func system(name:SystemImages) -> Image {
        return Image(systemName: name.rawValue)
    }
}

public extension UIImage {
     static func system(name:SystemImages) -> UIImage {
        return UIImage(systemName: name.rawValue) ?? UIImage()
    }
}

