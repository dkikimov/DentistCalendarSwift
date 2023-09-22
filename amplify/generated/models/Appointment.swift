// swiftlint:disable all
import Amplify
import Foundation

public struct Appointment: Model {
  public let id: String
  public var title: String?
  public var patientID: String?
  public var toothNumber: String?
  public var diagnosis: String?
  public var dateStart: String
  public var dateEnd: String
  public var payments: List<Payment>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String? = nil,
      patientID: String? = nil,
      toothNumber: String? = nil,
      diagnosis: String? = nil,
      dateStart: String,
      dateEnd: String,
      payments: List<Payment>? = []) {
    self.init(id: id,
      title: title,
      patientID: patientID,
      toothNumber: toothNumber,
      diagnosis: diagnosis,
      dateStart: dateStart,
      dateEnd: dateEnd,
      payments: payments,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      title: String? = nil,
      patientID: String? = nil,
      toothNumber: String? = nil,
      diagnosis: String? = nil,
      dateStart: String,
      dateEnd: String,
      payments: List<Payment>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.patientID = patientID
      self.toothNumber = toothNumber
      self.diagnosis = diagnosis
      self.dateStart = dateStart
      self.dateEnd = dateEnd
      self.payments = payments
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}