// swiftlint:disable all
import Amplify
import Foundation

extension Patient {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case fullname
    case phone
    case owner
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let patient = Patient.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", operations: [.create, .read, .delete, .update])
    ]
    
    model.pluralName = "Patients"
    
    model.fields(
      .id(),
      .field(patient.fullname, is: .required, ofType: .string),
      .field(patient.phone, is: .required, ofType: .string),
      .field(patient.owner, is: .optional, ofType: .string)
    )
    }
}