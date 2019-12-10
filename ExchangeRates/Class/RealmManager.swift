//
//  RealmManager.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 11.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import RealmSwift

class RealmManager {
    
    private let backgroundQueueLabel = "background"
    private let translator = RateTranslator()
        
    func reloadRates(rates: [Rate], completion: @escaping () -> Void) {
            
        var realmRates = [RealmRate]()
        for rate in rates {
            realmRates.append(translator.toObject(with: rate))
        }
            
        DispatchQueue(label: backgroundQueueLabel).async {
            autoreleasepool {
                guard let realm = try? Realm() else { completion(); return }
                try? realm.write {
                    realm.deleteAll()
                    realm.add(realmRates, update: .all)
                }
                completion()
            }
        }
    }
    
    
    func getStoredRates(completion: @escaping (_ rates: [Rate]) -> Void) {

        DispatchQueue(label: backgroundQueueLabel).async {
            autoreleasepool {
                var rates = [Rate]()
                guard let realm = try? Realm() else { return completion(rates) }
                let realmRates = realm.objects(RealmRate.self)
                for realmRate in realmRates {
                    rates.append(self.translator.toAny(with: realmRate))
                }
                completion(rates)
            }
        }
    }
}
