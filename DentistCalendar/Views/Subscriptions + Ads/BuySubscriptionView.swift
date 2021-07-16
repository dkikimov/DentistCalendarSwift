//
//  BuySubscriptionView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 03.01.2021.
//

import SwiftUI
import ApphudSDK
//import Adapty
struct BuySubscriptionView: View {
    let benefitsList = ["Больше никакой рекламы", "Синхронизируйте ваши данные", "Используйте на нескольких устройствах", "Импортируйте данные из календаря", "В будущем: генерируйте документы и выписки"]
    @Environment(\.presentationMode) var presentationMode
        @State var paywall: ApphudPaywall?
        @State var products: [ApphudProduct]?
//    @State var paywall: PaywallModel?
//    @State var selectedProduct: ProductModel?
        @State var selectedProduct: ApphudProduct?
    //    @EnvironmentObject private var store: Store
    //    @ObservedObject var productsStore : ProductsStore
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Разблокируйте:")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.leading, 2)
                VStack(alignment: .leading, spacing: 20) {
                    
                    //                        HStack {
                    //                            Spacer()
                    //                            Button(action: {
                    //                                presentationMode.wrappedValue.dismiss()
                    //
                    //                            }, label: {
                    //                                ZStack {
                    //                                    //                            Color("Gray1")
                    //                                    //                                .frame(width: 16, height: 16)
                    //                                    Image(systemName: "xmark.circle.fill")
                    //                                        .font(.title2, weight: .bold)
                    //                                        .foregroundColor(Color("Gray1"))
                    //                                }
                    //                            })
                    //                            .padding(.bottom, 5)
                    //                        }
                    //                        Text("Dentor Premium")
                    //                            .font(.largeTitle)
                    //                            .bold()
                    
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(benefitsList, id: \.self) { item in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("StaticBlue"))
                                Text(item.localized)
                                    .bold()
                                    .lineLimit(3)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    VStack {
                        if (paywall?.products != nil && (paywall?.products.count ?? 0) > 0) {
                                                    ForEach(self.products!, id: \.self) { product in
                                                        HStack {
                                                            Text(product.skProduct?.localizedTitle ?? "").bold()
                                                            Spacer()
                                                            VStack {
                        //                                        Text(String(product.suct?.subscriptionPeriod.numberOfUnits))
                                                                Text(product.skProduct?.localizedPrice() ?? "").bold()
                                                            }
                                                        }
                                                        .frame(maxWidth: 450)
                                                        .padding()
                                                        .background(Color("PrimaryColor"))
                                                        .foregroundColor(.white)
                                                        .clipShape(Rectangle())
                                                        .cornerRadius(8)
                        
                                                    }
                        }
                                               
//                        ForEach(paywall!.products, id: \.self) { product in
//                            HStack {
//                                Text(product.localizedTitle).bold()
//                                Spacer()
//                                VStack {
//                                    Text(product.localizedSubscriptionPeriod ?? "")
//                                    Text(product.localizedPrice ?? "").bold()
//                                }
//                            }
//                            .onTapGesture(perform: {
//                                self.selectedProduct = product
//                            })
//                            .frame(maxWidth: 450)
//                            .padding()
//                            .background(selectedProduct == product ? Color("PrimaryColor") : .white)
//                            .foregroundColor(selectedProduct == product ? .white : .black)
//                            .clipShape(Rectangle())
//                            .cornerRadius(8)
//                        }
//                                                } else {
//                                                    ProgressView()
//                                                }
                        HStack {
                            Spacer()
                            Button(action: {
                            }, label: {
                                Text("Восстановить покупки")
                                    .font(.caption)
                                    .bold()
                            })
                            Spacer()
                        }
                        HStack(spacing: 5) {
                            Spacer()
                            Link(destination: URL(string: "https://dentor-website.vercel.app/terms_of_use.html")!) {
                                Text("Условия использования")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(Color("Black1"))
                            }
                            //                    Button(action: {
                            //
                            //                    }, label: {
                            //                        Text("Условия использования")
                            //                            .font(.caption2)
                            //                            .bold()
                            //                            .foregroundColor(Color("Black1"))
                            //
                            //                    })
                            Link(destination: URL(string: "https://dentor-website.vercel.app/privacy_policy.html")!) {
                                Text("Политика конфиденциальности")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(Color("Black1"))
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                            //                    Button(action: {
                            //
                            //                    }, label: {
                            //                        Text("Политика конфиденциальности")
                            //                            .font(.caption2)
                            //                            .bold()
                            //                            .foregroundColor(Color("Black1"))
                            //                            .lineLimit(1)
                            //                    })
                            Spacer()
                        }
                    }
                    
                    Text(terms_text)
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                        .minimumScaleFactor(0.8)
                        .lineBreakMode(.byWordWrapping)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Spacer()
                        Button(action: {
//                            Adapty.makePurchase(product: selectedProduct) { (purchaserInfo, receipt, appleValidationResult, product, error) in
//                                if error == nil {
//                                    print("SUCCESSFUL PURCHASE", product)
//                                    print("Purchaser info ", purchaserInfo)
//                                    print("validation result ", appleValidationResult)
//                                } else {
//                                    print("Error when buying subscription", error!.localizedDescription)
//                                }
//                            }
                        }, label: {
                            
                            Text("Подписаться")
                                .bold()
                                .frame(maxWidth: 450)
                                .padding()
                        })
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .clipShape(Rectangle())
                        .cornerRadius(8)
                        
                        //                        GeometryReader { geom in
                        //                            ActionButton(buttonLabel: "Подписаться", maxWidth: geom.size.width + 50) {
                        //
                        //                            }
                        //                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            .padding(.top, 1)
            .navigationBarTitle(Text("Dentor Premium"), displayMode: .automatic)
            .navigationBarColor(backgroundColor: UIColor(named: "White1")!, tintColor: UIColor(named: "Black1")!, shadowColor: .clear, buttonsColor: UIColor(named: "Gray1"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        CloseButton(presentationMode: presentationMode)
                    }
                }
                
            }
            .onAppear {
//                Adapty.getPaywalls { (paywalls, _, error) in
//                    self.paywall = paywalls?.first(where: { $0.developerId == "default_paywall" })
//                    if let paywall = paywall {
//                        self.selectedProduct = paywall.products.first
//                    }
//                }
                                Apphud.getPaywalls { (paywalls, error) in
                                      if error == nil {
                                        // retrieve current paywall with identifier
                                        self.paywall = paywalls?.first(where: { $0.identifier == "default_paywall" })
                
                                        // retrieve the products [ApphudProduct] from current paywall
                                        self.products = paywall?.products
                
                                      }
                                    }
            }
        }
        //        }.frame(maxHeight: UIScreen.main.bounds.height)
    }
    
}
//struct BuySubscriptionView: View {
//    @State var selectedDate = Date()
//    var body: some View {
//        Form {
//            DatePicker("When is your birthday?", selection: $selectedDate, displayedComponents: .date)
//                .datePickerStyle(GraphicalDatePickerStyle())
//        }
//    }
//}
