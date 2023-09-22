// swiftlint:disable all
import Amplify
import Foundation

public struct Patient: Model {
  public let id: String
  public var fullname: String
  public var phone: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      fullname: String,
      phone: String? = nil) {
    self.init(id: id,
      fullname: fullname,
      phone: phone,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      fullname: String,
      phone: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.fullname = fullname
      self.phone = phone
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}