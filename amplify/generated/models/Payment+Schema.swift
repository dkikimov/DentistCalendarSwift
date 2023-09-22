// swiftlint:disable all
import Amplify
import Foundation

extension Payment {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case appointmentID
    case cost
    case date
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let payment = Payment.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Payments"
    
    model.attributes(
      .index(fields: ["appointmentID"], name: "byAppointment")
    )
    
    model.fields(
      .id(),
      .field(payment.appointmentID, is: .required, ofType: .string),
      .field(payment.cost, is: .required, ofType: .string),
      .field(payment.date, is: .required, ofType: .string),
      .field(payment.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(payment.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}