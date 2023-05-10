// swiftlint:disable all
import Amplify
import Foundation

public struct Appointment: Model {
  public let id: String
  public var title: String
  public var patientID: String?
  public var owner: String?
  public var toothNumber: Int?
  public var diagnosis: String?
  public var price: Int?
  public var dateStart: String
  public var dateEnd: String
  
  public init(id: String = UUID().uuidString,
      title: String,
      patientID: String? = nil,
      owner: String? = nil,
      toothNumber: Int? = nil,
      diagnosis: String? = nil,
      price: Int? = nil,
      dateStart: String,
      dateEnd: String) {
      self.id = id
      self.title = title
      self.patientID = patientID
      self.owner = owner
      self.toothNumber = toothNumber
      self.diagnosis = diagnosis
      self.price = price
      self.dateStart = dateStart
      self.dateEnd = dateEnd
  }
}