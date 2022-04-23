//
//  MediaContentTypes.swift
//  GpHealthPlus
//
//  Created by sn99 on 19/08/20.
//

import Foundation



public class MediaContentTypes {
    //doc
    static let TEXT_PLAIN = "text/plain"
    static let TEXT_HTML = "text/html"
    static let TEXT_VCALENDAR = "text/x-vCalendar"
    static let TEXT_VCARD = "text/x-vCard"
    static let APP_PDF = "application/pdf"
    
    //image
    static let IMAGE_JPEG = "image/jpeg"
    static let IMAGE_JPG = "image/jpg"
    static let IMAGE_GIF = "image/gif"
    static let IMAGE_WBMP = "image/vnd.wap.wbmp"
    static let IMAGE_PNG = "image/png"
    static let IMAGE_BMP = "image/bmp"
    static let IMAGE_WEBP = "image/webp"
    
    //audio
    static let AUDIO_AAC = "audio/aac"
    static let AUDIO_AMR = "audio/amr"
    static let AUDIO_IMELODY = "audio/imelody"
    static let AUDIO_MID = "audio/mid"
    static let AUDIO_MIDI = "audio/midi"
    static let AUDIO_MPEG3 = "audio/mpeg3"
    static let AUDIO_MPEG = "audio/mpeg"
    static let AUDIO_MP3 = "audio/mp3"
    static let AUDIO_MPG = "audio/mpg"
    static let AUDIO_MP4 = "audio/mp4"
    static let AUDIO_X_MID = "audio/x-mid"
    static let AUDIO_X_MIDI = "audio/x-midi"
    static let AUDIO_X_MP3 = "audio/x-mp3"
    static let AUDIO_X_MPEG3 = "audio/x-mpeg3"
    static let AUDIO_X_MPEG = "audio/x-mpeg"
    static let AUDIO_X_MPG = "audio/x-mpg"
    static let AUDIO_3GPP = "audio/3gpp"
    static let AUDIO_OGG = "audio/ogg"
    static let AUDIO_M4A = "audio/m4a"
    static let AUDIO_3GP = "audio/3gp"
    
    static let AUDIO_WAVE = "audio/wav"
    static let AUDIO_VORBIS = "audio/mkv"
    static let AUDIO_FLAC = "audio/flac"
    
    //video
    static let VIDEO_3GPP = "video/3gp"
    static let VIDEO_3G2 = "video/3gpp2"
    static let VIDEO_H263 = "video/h263"
    static let VIDEO_MP4 = "video/mp4"
    static let VIDEO_MOV = "video/mov"
    
    //   static let VIDEO_AAC = "video/aac"
    static let VIDEO_WEBM = "video/webm"
    static let VIDEO_MKV = "video/mkv"
    
    static let APP_SMIL = "application/smil"
    static let APP_WAP_XHTML = "application/vnd.wap.xhtml+xml"
    static let APP_XHTML = "application/xhtml+xml"
    
    static let APP_DRM_CONTENT = "application/vnd.oma.drm.content"
    static let APP_DRM_MESSAGE = "application/vnd.oma.drm.message"


    static let TEXT = "Text"
    static let FILE = "File"
    
    static let CONTENT_TYPE_TEXT = "txt"
     static let CONTENT_TYPE_IMAGE = "image"
     static let CONTENT_TYPE_AUDIO = "audio"
     static let CONTENT_TYPE_VIDEO = "video"
     static let CONTENT_TYPE_DOC = "doc"
     static let CONTENT_TYPE_PDF = "pdf"
     static let CONTENT_TYPE_PPT = "ppt"
     static let CONTENT_TYPE_XLS = "xls"
     static let CONTENT_TYPE_SIGNATURE = "sign"
    
    
    
    static var sSupportedContentTypes = [String]()
       static var sSupportedImageTypes = [String]()
       static var sSupportedAudioTypes = [String]()
       static var sSupportedVideoTypes = [String]()
       
    /*
     
    
    init() {
        sSupportedContentTypes.append(TEXT_PLAIN)
        sSupportedContentTypes.append(TEXT_HTML)
        sSupportedContentTypes.append(TEXT_VCALENDAR)
        sSupportedContentTypes.append(TEXT_VCARD)
        
        
        sSupportedContentTypes.append(IMAGE_JPEG)
        sSupportedContentTypes.append(IMAGE_GIF)
        sSupportedContentTypes.append(IMAGE_WBMP)
        sSupportedContentTypes.append(IMAGE_PNG)
        sSupportedContentTypes.append(IMAGE_JPG)
        sSupportedContentTypes.append(IMAGE_BMP)
        sSupportedContentTypes.append(IMAGE_WEBP)
        
        sSupportedContentTypes.append(AUDIO_AAC)
        sSupportedContentTypes.append(AUDIO_AMR)
        sSupportedContentTypes.append(AUDIO_IMELODY)
        sSupportedContentTypes.append(AUDIO_MID)
        sSupportedContentTypes.append(AUDIO_MIDI)
        sSupportedContentTypes.append(AUDIO_MP3)
        sSupportedContentTypes.append(AUDIO_MPEG3)
        sSupportedContentTypes.append(AUDIO_MPEG)
        sSupportedContentTypes.append(AUDIO_MPG)
        sSupportedContentTypes.append(AUDIO_X_MID)
        sSupportedContentTypes.append(AUDIO_X_MIDI)
        sSupportedContentTypes.append(AUDIO_X_MP3)
        sSupportedContentTypes.append(AUDIO_X_MPEG3)
        sSupportedContentTypes.append(AUDIO_X_MPEG)
        sSupportedContentTypes.append(AUDIO_X_MPG)
        sSupportedContentTypes.append(AUDIO_3GPP)
        sSupportedContentTypes.append(AUDIO_OGG)
        sSupportedContentTypes.append(AUDIO_M4A)
        sSupportedContentTypes.append(AUDIO_WAVE)
        sSupportedContentTypes.append(AUDIO_OGG)
        sSupportedContentTypes.append(AUDIO_VORBIS)
        sSupportedContentTypes.append(AUDIO_FLAC)
        
        sSupportedContentTypes.append(VIDEO_3GPP)
        sSupportedContentTypes.append(VIDEO_3G2)
        sSupportedContentTypes.append(VIDEO_H263)
        sSupportedContentTypes.append(VIDEO_MP4)
        sSupportedContentTypes.append(VIDEO_WEBM)
        sSupportedContentTypes.append(VIDEO_MKV)
        sSupportedContentTypes.append(VIDEO_MOV)
        
        sSupportedContentTypes.append(APP_SMIL)
        sSupportedContentTypes.append(APP_WAP_XHTML)
        sSupportedContentTypes.append(APP_XHTML)
        
        sSupportedContentTypes.append(APP_DRM_CONTENT)
        sSupportedContentTypes.append(APP_DRM_MESSAGE)
        
        // append supported image types
        sSupportedImageTypes.append(IMAGE_JPEG)
        sSupportedImageTypes.append(IMAGE_GIF)
        sSupportedImageTypes.append(IMAGE_WBMP)
        sSupportedImageTypes.append(IMAGE_PNG)
        sSupportedImageTypes.append(IMAGE_JPG)
        sSupportedImageTypes.append(IMAGE_BMP)
        sSupportedImageTypes.append(IMAGE_WEBP)
        // append supported audio types
        sSupportedAudioTypes.append(AUDIO_AAC)
        sSupportedAudioTypes.append(AUDIO_AMR)
        sSupportedAudioTypes.append(AUDIO_IMELODY)
        sSupportedAudioTypes.append(AUDIO_MID)
        sSupportedAudioTypes.append(AUDIO_MIDI)
        sSupportedAudioTypes.append(AUDIO_MP3)
        sSupportedAudioTypes.append(AUDIO_MPEG3)
        sSupportedAudioTypes.append(AUDIO_MPEG)
        sSupportedAudioTypes.append(AUDIO_MPG)
        sSupportedAudioTypes.append(AUDIO_MP4)
        sSupportedAudioTypes.append(AUDIO_X_MID)
        sSupportedAudioTypes.append(AUDIO_X_MIDI)
        sSupportedAudioTypes.append(AUDIO_X_MP3)
        sSupportedAudioTypes.append(AUDIO_X_MPEG3)
        sSupportedAudioTypes.append(AUDIO_X_MPEG)
        sSupportedAudioTypes.append(AUDIO_X_MPG)
        sSupportedAudioTypes.append(AUDIO_3GPP)
        sSupportedAudioTypes.append(AUDIO_OGG)
        sSupportedAudioTypes.append(AUDIO_M4A)
        sSupportedAudioTypes.append(AUDIO_3GP)
        sSupportedAudioTypes.append(AUDIO_WAVE)
        sSupportedAudioTypes.append(AUDIO_VORBIS)
        sSupportedAudioTypes.append(AUDIO_FLAC)
        
        // append supported video types
        sSupportedVideoTypes.append(VIDEO_3GPP)
        sSupportedVideoTypes.append(VIDEO_3G2)
        sSupportedVideoTypes.append(VIDEO_H263)
        sSupportedVideoTypes.append(VIDEO_MP4)
        // sSupportedVideoTypes.append(VIDEO_AAC)
        sSupportedVideoTypes.append(VIDEO_WEBM)
        sSupportedVideoTypes.append(VIDEO_MKV)
        sSupportedVideoTypes.append(VIDEO_MOV)
    }
    
    */
    
    
    static func isTextType(contentType:String) -> Bool {
        return contentType.starts(with: "text")
    }
    
    static func isImageType(contentType:String) -> Bool {
        return contentType.starts(with: "image")
    }
    
    static func isAudioType(contentType:String) -> Bool {
        return contentType.starts(with: "audio")
    }
    
    static func isVideoType(contentType:String) -> Bool {
        return contentType.starts(with: "video")
    }
    
    static func isZipType(contentType:String) -> Bool {
        return contentType.contains("zip")
    }
    
    static func isPdfType(contentType:String) -> Bool {
        return contentType.contains("pdf")
    }
    
    static func isDocType(contentType:String) -> Bool {
        return contentType.contains("doc") || contentType.contains("docx")
    }
    
    static func isXlsType(contentType:String) -> Bool {
        return contentType.contains("xls") || contentType.contains("xlsx")
    }
    
    static func isPPtDocType(contentType:String) -> Bool {
        return contentType.contains("ppt") || contentType.contains("pptx")
    }
    
   static func isDocumentType(fileType:String) -> Bool {
        return !isImageType(contentType: fileType) && !isVideoType(contentType: fileType) && !isAudioType(contentType: fileType)
    }
    
    
    
    private static func getMediaTypeFromPath(attachmentPath:String) -> String {
        let pathExtension = attachmentPath.pathExtension.lowercased()
        
        
        if pathExtension == "txt" {
            return TEXT_PLAIN
        }
            
        else if pathExtension == "pdf"{
            return APP_PDF
        }
        else if pathExtension == "txt" {
            return "txt"
        }
            
            // Image
        else if pathExtension == "jpeg" {
            return IMAGE_JPEG
        }
        else if pathExtension == "jpg" {
            return IMAGE_JPG
        }
        else if pathExtension == "gif" {
            return IMAGE_GIF
        }
        else if pathExtension == "png" {
            return IMAGE_PNG
        }
        else if pathExtension == "webp" {
            return IMAGE_WEBP
        }
        else if pathExtension == "bmp" {
            return IMAGE_BMP
        }
            
            // Video
        else if pathExtension == "mp4" {
            return VIDEO_MP4
        }
        else if pathExtension == "webm" {
            return VIDEO_WEBM
        }
        else if pathExtension == "mkv" {
            return VIDEO_MKV
        }
        else if pathExtension == "mov" {
            return VIDEO_MOV
        }
        else if pathExtension == "h263" {
            return VIDEO_H263
        }
        else if pathExtension == "3gpp2" {
            return VIDEO_3G2
        }
        else if pathExtension == "3gp" {
            return VIDEO_3GPP
        }
            
            //Audio
        else if pathExtension == "aac" {
            return AUDIO_AAC
        }
        else if pathExtension == "amr" {
            return AUDIO_AMR
        }
        else if pathExtension == "imelody" {
            return AUDIO_IMELODY
        }
        else if pathExtension == "mid" {
            return AUDIO_MID
        }
        else if pathExtension == "midi" {
            return AUDIO_MIDI
        }
        else if pathExtension == "mp3" {
            return AUDIO_MP3
        }
        else if pathExtension == "mpeg3" {
            return AUDIO_MPEG3
        }
        else if pathExtension == "mpeg" {
            return AUDIO_MPEG
        }
        else if pathExtension == "mpg" {
            return AUDIO_MPG
        }
        else if pathExtension == "mp4" {
            return AUDIO_MP4
        }
        else if pathExtension == "x-mid" {
            return AUDIO_X_MIDI
        }
        else if pathExtension == "x-mp3" {
            return AUDIO_X_MP3
        }
        else if pathExtension == "x-mpeg3" {
            return AUDIO_X_MPEG3
        }
        else if pathExtension == "x-mpeg" {
            return AUDIO_X_MPEG
        }
        else if pathExtension == "x-mpg" {
            return AUDIO_X_MPG
        }
        else if pathExtension == "3gpp" {
            return AUDIO_3GPP
        }
        else if pathExtension == "ogg" {
            return AUDIO_OGG
        }
        else if pathExtension == "3gp" {
            return AUDIO_3GP
        }
        else if pathExtension == "m4a" {
            return AUDIO_M4A
        }
        else if pathExtension == "wav" {
            return AUDIO_WAVE
        }
        else if pathExtension == "mkv" {
            return AUDIO_VORBIS
        }
        else if pathExtension == "flac" {
            return AUDIO_FLAC
        }
        return pathExtension
    }
    
    
    static func getContentTypeServerCode(filePath:String) -> String {
        
        let mediaType = getMediaTypeFromPath(attachmentPath: filePath)
        
        if isAudioType(contentType: mediaType) {
            return self.CONTENT_TYPE_AUDIO
        }else if isVideoType(contentType: mediaType) {
            return self.CONTENT_TYPE_VIDEO
        }else if isImageType(contentType: mediaType) {
            return CONTENT_TYPE_IMAGE
        }else if isPdfType(contentType: mediaType) {
            return CONTENT_TYPE_PDF
        }else if isTextType(contentType: mediaType) {
            return CONTENT_TYPE_TEXT
        }else if isDocType(contentType: mediaType) {
            return CONTENT_TYPE_DOC
        }else if isPPtDocType(contentType: mediaType) {
            return CONTENT_TYPE_PPT
        }else if isXlsType(contentType: mediaType) {
            return CONTENT_TYPE_XLS
        }
        
        return CONTENT_TYPE_DOC
    }
    
    
}
