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
        UTType(exportedAs: "com.daniilkikimov.dentor.ics")
    }
}
extension UTType {
    static var icsImport: UTType {
        UTType(importedAs: "com.daniilkikimov.dentor.ics")
    }
}
struct ExportDocument: FileDocument {
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
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
    
}
