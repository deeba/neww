//
//  QRCodeReaderResult.swift
//  HSpace
//
//  Created by DEEBA on 03.08.20.
//  Copyright © 2020 Dabus.tv. All rights reserved.
//
import Foundation

/**
 The result of the scan with its content value and the corresponding metadata type.
 */
public struct QRCodeReaderResult {
  /**
   The error corrected data decoded into a human-readable string.
   */
  public let value: String

  /**
   The type of the metadata.
   */
  public let metadataType: String
}
