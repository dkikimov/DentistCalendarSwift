// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "21853935a048bfb9bd7afeeb49549dc4"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Patient.self)
    ModelRegistry.register(modelType: Appointment.self)
    ModelRegistry.register(modelType: Payment.self)
  }
}