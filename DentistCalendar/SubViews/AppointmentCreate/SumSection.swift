//
//  SumSection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 16.01.2021.
//

import SwiftUI

struct SumSection: View {
    @EnvironmentObject var data: AppointmentCreateViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Общая стоимость: ").bold() + Text(NSDecimalNumber(decimal: data.sumPrices).stringValue)
            Text("Оплачено: ").bold() + Text(NSDecimalNumber(decimal: data.sumPayment).stringValue)
            Text("Осталось к оплате: ").bold() + Text(NSDecimalNumber(decimal: data.sumPrices - data.sumPayment).stringValue)
        }
    }
}

struct SumSection_Previews: PreviewProvider {
    static var previews: some View {
        SumSection()
    }
}
