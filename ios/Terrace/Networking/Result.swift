//
//  Result.swift
//  Terrace
//
//  Created by Avery Lamp on 1/19/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//

enum Result<T, Error> {
  case success(T)
  case failure(Error)
}
