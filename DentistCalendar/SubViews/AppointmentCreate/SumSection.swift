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
            Text("Общая стоимость: ").bold() + Text(data.sumPrices.currencyFormatted)
            Text("Оплачено: ").bold() + Text(data.sumPayment.currencyFormatted)
            Text("Осталось к оплате: ").bold() + Text((data.sumPrices - data.sumPayment).currencyFormatted)
        }
    }
}

struct SumSection_Previews: PreviewProvider {
    static var previews: some View {
        SumSection()
    }
}
