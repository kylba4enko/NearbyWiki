//
//  PlacesRequestService.swift
//  NearbyWiki
//
//  Created by Max Kulbachenko on 27.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import Alamofire
import Moya
import RxSwift

protocol PointOfInterestRequestService {
    func fetchPointOfInterestDetails(_ identifier: Int) -> Single<PointOfInterestDetails>
    func fetchPointOfInterests(latitude: Double,
                               longitude: Double,
                               radius: Int,
                               limit: Int) -> Single<[PointOfInterest]>
}

final class PointOfInterestRequestServiceImpl: PointOfInterestRequestService {

    private let provider = MoyaProvider<PointOfInterestTarget>()

    func fetchPointOfInterests(latitude: Double,
                               longitude: Double,
                               radius: Int,
                               limit: Int) -> Single<[PointOfInterest]> {

        return Single<[PointOfInterest]>.create { single in
            self.provider.request(.getPointOfInterestList(latitude, longitude, radius, limit)) { result in
                switch result {
                case .success(let response):
                    if let dict = response.data.toDictionary(),
                        let query = dict["query"] as? [String: Any],
                        let geoSearch = query["geosearch"] as? [Any],
                        let data = geoSearch.toData(),
                        let pois = try? JSONDecoder().decode([PointOfInterest].self, from: data) {

                        single(.success(pois))
                    } else {
                        single(.error(MoyaError.jsonMapping(response)))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func fetchPointOfInterestDetails(_ identifier: Int) -> Single<PointOfInterestDetails> {
        return Single<PointOfInterestDetails>.create { single in
            self.provider.request(.getPointOfInterestDetails(identifier)) { result in
                switch result {
                case .success(let response):
                    if let dictionary = response.data.toDictionary(),
                        let query = dictionary["query"] as? [String: Any],
                        let pages = query["pages"] as? [String: Any],
                        let page = pages["\(identifier)"] as? [String: Any],
                        let data = page.toData(),
                        let poi = try? JSONDecoder().decode(PointOfInterestDetails.self, from: data) {

                        single(.success(poi))
                    } else {
                        single(.error(MoyaError.jsonMapping(response)))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
