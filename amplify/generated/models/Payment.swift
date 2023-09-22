// swiftlint:disable all
import Amplify
import Foundation

public struct Payment: Model {
  public let id: String
  public var appointmentID: String
  public var cost: String
  public var date: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      appointmentID: String,
      cost: String,
      date: String) {
    self.init(id: id,
      appointmentID: appointmentID,
      cost: cost,
      date: date,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      appointmentID: String,
      cost: String,
      date: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.appointmentID = appointmentID
      self.cost = cost
      self.date = date
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}