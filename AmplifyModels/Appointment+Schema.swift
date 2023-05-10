// swiftlint:disable all
import Amplify
import Foundation

extension Appointment {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case patientID
    case owner
    case toothNumber
    case diagnosis
    case price
    case dateStart
    case dateEnd
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let appointment = Appointment.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", operations: [.create, .read, .delete, .update])
    ]
    
    model.pluralName = "Appointments"
    
    model.fields(
      .id(),
      .field(appointment.title, is: .required, ofType: .string),
      .field(appointment.patientID, is: .optional, ofType: .string),
      .field(appointment.owner, is: .optional, ofType: .string),
      .field(appointment.toothNumber, is: .optional, ofType: .int),
      .field(appointment.diagnosis, is: .optional, ofType: .string),
      .field(appointment.price, is: .optional, ofType: .int),
      .field(appointment.dateStart, is: .required, ofType: .string),
      .field(appointment.dateEnd, is: .required, ofType: .string)
    )
    }
}