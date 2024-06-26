//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Оксана Аралина on 24.06.2024.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
