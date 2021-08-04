//
//  BuySubscriptionView.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 03.01.2021.
//

import SwiftUI
import ApphudSDK
import Appodeal
import StoreKit
//import Adapty
//"В будущем: генерируйте документы и выписки"
struct BuySubscriptionView: View {
    let benefitsList = ["Больше никакой рекламы", "Синхронизируйте ваши данные", "Используйте на нескольких устройствах", "Экспортируйте ваши данные", "Создавайте и редактируйте записи без доступа в Интернет"]
    @Environment(\.presentationMode) var presentationMode
    @State var paywall: ApphudPaywall?
    @State var products = [ApphudProduct]()
    //    @State var paywall: PaywallModel?
    //    @State var selectedProduct: ProductModel?
    @State var selectedProduct: ApphudProduct?
    @State var error = ""
    @State var title = "Ошибка"
    @State var isAlertPresented = false
    @StateObject var networkManager = InternetConnectionManager()
    @State var introductoryPrice: SKProductDiscount?
    @State var isEligibleForOffer: Bool = false
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
                        
                        //                        if Apphud.checkEligibilityForIntroductoryOffer(product: selectedProduct!) {
                        if isEligibleForOffer && introductoryPrice != nil {
                            //                                Text("Ваши первые") + Text(" \(introductoryPrice!.price.intValue)") + Text(" \(introductoryPrice!.subscriptionPeriod.localizedPeriod()) ") + Text("бесплатны")
                            Text("Ваши первые \(introductoryPrice!.subscriptionPeriod.localizedPeriod()) бесплатны. Оплата только по истечению пробного периода.")
                                .bold()
                                .foregroundColor(.gray)
                                .font(.body)
                                .padding(.top, 8)
                                .animation(.easeInOut)
                                .transition(.opacity)

                        }
                        
                        
                        //
                        //                        }
                    }
                    
                    VStack {
                        if !networkManager.isInternetConnected {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.red)
                                Text("Для совершения покупки необходим доступ в Интернет")
                            }
                            .padding([.top, .bottom])
                            .font(Font.body.bold())
                            .frame(maxWidth: .infinity)
                        }
                        else if self.products.count > 0 {
                            ForEach(self.products, id: \.self) { product in
                                HStack {
                                    if product.skProduct?.subscriptionPeriod != nil {
                                        Text(product.skProduct!.subscriptionPeriod!.localizedPeriod())
                                            .bold()
                                    } else {
                                        Text("Ошибка")
                                    }
                                    Spacer()
                                    Text(product.skProduct?.localizedPrice() ?? "").bold()
                                    
                                }
                                .frame(maxWidth: 450)
                                .padding()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.selectedProduct = product
                                }
                                .background(selectedProduct == product ? Color("PrimaryColor") : Color("PrimaryColor2"))
                                .foregroundColor(selectedProduct == product ? .white : Color("Black1"))
                                .cornerRadius(8)
                                
                                
                            }
                        }
                        if self.products.count == 0 {
                            ProgressView()
                                .padding()
                        }
                        
                        
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                Apphud.restorePurchases { subscriptions, nonRenewingPurch, err in
                                    //                                    DispatchQueue.main.asyncAfter(deadline: .now + .seconds(1)) {
                                    if Apphud.hasActiveSubscription() {
                                        self.title = "Успех!"
                                        self.error = "Покупки успешно восстановлены!"
                                        self.isAlertPresented = true
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                    else if let err = err {
                                        self.title = "Ошибка"
                                        self.error = err.localizedDescription
                                        self.isAlertPresented = true
                                    } else {
                                        self.title = "Ошибка"
                                        self.error = "Покупки не были найдены"
                                        self.isAlertPresented = true
                                    }
                                    //                                    }
                                }
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
                            Link(destination: URL(string: "https://dentor-website.vercel.app/privacy_policy.html")!) {
                                Text("Политика конфиденциальности")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(Color("Black1"))
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                    }
                    
                    Text(terms_text.localized)
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
                            guard networkManager.isInternetConnected else {
                                self.title = "Ошибка".localized
                                self.error = "Для совершения покупки необходим доступ в Интернет".localized
                                self.isAlertPresented = true
                                return
                            }
                            Apphud.purchase(selectedProduct!) { result in
                                if let subscription = result.subscription, subscription.isActive(){
                                    print("HAVE SUBSCRIPTION")
                                    presentationMode.wrappedValue.dismiss()
                                } else if let purchase = result.nonRenewingPurchase, purchase.isActive(){
                                    // has active non-renewing purchase
                                } else {
                                    // handle error or check transaction status.
                                }
                            }
                        }, label: {
                            
                            Text("Подписаться")
                                .bold()
                                .frame(maxWidth: 450)
                                .padding()
                        })
                        .disabled(selectedProduct == nil)
                        .background(selectedProduct != nil ? Color("PrimaryColor") : Color.gray)
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
            //            .transition(.easeInOut)
            .onChange(of: networkManager.isInternetConnected) { isInternetConnected in
                checkInternetConnection(isInternetConnected)
            }
            .alert(isPresented: $isAlertPresented, content: {
                Alert(title: Text(title), message: Text(error), dismissButton: .cancel())
            })
            .padding(.top, 1)
            .navigationBarTitle(Text("Dentor Premium"), displayMode: .automatic)
            .navigationBarColor(backgroundColor: UIColor(named: "White1")!, tintColor: UIColor(named: "Black1")!, shadowColor: .clear, buttonsColor: UIColor(named: "Gray1"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    
//                    HStack {
                        CloseButton(presentationMode: presentationMode)
//                    }
                }
                
            }
            .onAppear {
                checkInternetConnection(networkManager.isInternetConnected)
            }
            
        }
        //        }.frame(maxHeight: UIScreen.main.bounds.height)
    }
    private func getProducts() {
        Apphud.getPaywalls { (paywalls, error) in
            if error == nil {
                // retrieve current paywall with identifier
                self.paywall = paywalls?.first(where: { $0.identifier == "default_paywall" })
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0.35)) {
                    if let paywallProducts = paywall?.products {
                        self.products = paywallProducts
    //                    withAnimation {
                        withAnimation {
                                self.selectedProduct = products.first
                            }
                        
    //                    }
                        self.introductoryPrice = selectedProduct?.skProduct?.introductoryPrice
                        checkIntroductoryOffer()
                    }
                }
                
                //                                            }
                
            }
            
        }
        
        
    }
    
    private func checkIntroductoryOffer() {
        if let skProduct = selectedProduct?.skProduct {
            Apphud.checkEligibilityForIntroductoryOffer(product: skProduct) { res in
                withAnimation {
                    print("isEligibleForOffer", res)
                    self.isEligibleForOffer = res
                }
            }
        }
    }
    private func checkInternetConnection(_ isInternetConnected: Bool) {
        if isInternetConnected {
            getProducts()
        }
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

//struct BuySubscriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        BuySubscriptionView()
//            .environmentObject(EnvironmentObject.pre)
//
//    }
//}
