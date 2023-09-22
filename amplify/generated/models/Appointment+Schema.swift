// swiftlint:disable all
import Amplify
import Foundation

extension Appointment {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case patientID
    case toothNumber
    case diagnosis
    case dateStart
    case dateEnd
    case payments
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let appointment = Appointment.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Appointments"
    
    model.fields(
      .id(),
      .field(appointment.title, is: .optional, ofType: .string),
      .field(appointment.patientID, is: .optional, ofType: .string),
      .field(appointment.toothNumber, is: .optional, ofType: .string),
      .field(appointment.diagnosis, is: .optional, ofType: .string),
      .field(appointment.dateStart, is: .required, ofType: .string),
      .field(appointment.dateEnd, is: .required, ofType: .string),
      .hasMany(appointment.payments, is: .optional, ofType: Payment.self, associatedWith: Payment.keys.appointmentID),
      .field(appointment.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(appointment.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}