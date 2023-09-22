// swiftlint:disable all
import Amplify
import Foundation

extension Patient {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case fullname
    case phone
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let patient = Patient.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Patients"
    
    model.fields(
      .id(),
      .field(patient.fullname, is: .required, ofType: .string),
      .field(patient.phone, is: .optional, ofType: .string),
      .field(patient.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(patient.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}