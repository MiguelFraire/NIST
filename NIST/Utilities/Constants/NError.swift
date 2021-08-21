//
//  NError.swift
//  NIST
//
//  Created by Miguel Fraire on 7/30/21.
//

import Foundation

enum NError: String, Error {
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case invalidQuery       = "Your query is invalid. Please try again."
}
