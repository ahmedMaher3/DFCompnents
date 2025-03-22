//
//  FormEntity.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/24/25.
//

struct FormEntity {
    var pages: [PageEntity]
    var rules: [Rule]
    let warnings: WarningsEntity?
    let header: ClassicPageHeader?
    let footer: ClassicPageFooter?
    let welcome: CardWelcomeData?
}
