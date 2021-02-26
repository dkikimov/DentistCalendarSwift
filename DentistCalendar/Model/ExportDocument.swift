//
//  ExportDocument.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 14.02.2021.
//

import SwiftUI
import UniformTypeIdentifiers
extension UTType {
    static var ics: UTType {
        UTType(exportedAs: "com.katsushooter.DentistCalendar.ics")
//        UTType(

//        UTType(importedAs: "com.katsushooter.DentistCalendar.ics")
    }
}
extension UTType {
    static var icsImport: UTType {
        UTType(importedAs: "com.katsushooter.DentistCalendar.ics")
    }
}
struct ExportDocument: FileDocument {
    
    //    let type = UTType(filenameExtension: "opml")
    static var readableContentTypes: [UTType] { [.ics] }
    static var writableContentTypes: [UTType] { [.ics] }
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }
//    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
//        // Create a FileWrapper with the updated contents and set fileWrapper to it.
//        // This is possible because fileWrapper is an inout parameter.
//    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
    
}
