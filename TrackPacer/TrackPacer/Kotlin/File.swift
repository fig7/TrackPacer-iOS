//
//  File.swift
//  TrackPacer
//
//  Created by Stuart Fisher on 24/05/2024.
//

import Foundation

enum FileError : Error { case FileCreationError, FileReadError, FileDataError, FolderCreationError }

struct File {
  let url: URL
  let fm = FileManager.default

  init(url: URL) {
    self.url = url
  }

  init(url: URL, child: String, directoryHint: URL.DirectoryHint) {
    self.url = url.appending(path: child, directoryHint: directoryHint)
  }

  init(file: File, child: String, directoryHint: URL.DirectoryHint) {
    self.init(url: file.url, child: child, directoryHint: directoryHint)
  }

  func exists() -> Bool { return fm.fileExists(atPath: url.path(percentEncoded: false)) }
  func mkdir() throws -> Bool { try fm.createDirectory(at: url, withIntermediateDirectories: false); return true }

  func list() throws -> [String] {
    return try fm.contentsOfDirectory(atPath: url.path(percentEncoded: false))
  }

  func readText() throws -> String {
    let data = NSData(contentsOf: url) as Data?
    guard let data else { throw FileError.FileReadError }

    let text = String(data: data, encoding: .utf8)
    guard let text else { throw FileError.FileDataError }

    return text
  }

  func writeText(_ text: String) throws {
    try text.write(to: url, atomically: true, encoding: .utf8)
  }
}
