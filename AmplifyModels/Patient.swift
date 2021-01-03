// swiftlint:disable all
import Amplify
import Foundation

public struct Patient: Model {
  public let id: String
  public var fullname: String
  public var phone: String
  public var owner: String?
  
  public init(id: String = UUID().uuidString,
      fullname: String,
      phone: String,
      owner: String? = nil) {
      self.id = id
      self.fullname = fullname
      self.phone = phone
      self.owner = owner
  }
}