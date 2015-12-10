//
//  NSCoding+FileKit.swift
//  FileKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

// public typealias CodingFile<T: NSCoding> = File<DataCoding<T>>

/// Wrapper to adapt any `NSCoding` object to `DataType`.
public struct DataCoding<T: NSCoding>: RawRepresentable {
    public typealias RawValue = T

    public let rawValue: T
    public init(rawValue: T) {
        self.rawValue = rawValue
    }
}

// MARK: Readable
extension DataCoding: Readable {

    public static func readFromPath(path: Path) throws -> DataCoding {
        let data: NSData = try NSData.readFromPath(path)
        guard let object = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? T else {
            throw FileKitError.ReadFromFileFail(path: path)
        }
        return DataCoding(rawValue: object)
    }

}

// MARK: Writable
extension DataCoding: WritableConvertible {

    public typealias WritableType = NSData

    public var writable: NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self.rawValue)
    }

}