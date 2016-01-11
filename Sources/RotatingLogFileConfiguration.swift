//
//  RotatingLogFileConfiguration.swift
//  CleanroomLogger
//
//  Created by Evan Maloney on 12/31/15.
//  Copyright © 2015 Gilt Groupe. All rights reserved.
//

import Foundation

/**
 A `LogConfiguration` that uses an underlying `RotatingLogFileRecorder` to
 maintain a directory of log files that are rotated on a daily basis.
 */
public class RotatingLogFileConfiguration: BasicLogConfiguration
{
    /** The filesystem path to a directory where the log files will be
     stored. */
    public var directoryPath: String {
        return logFileRecorder.directoryPath
    }

    private let logFileRecorder: RotatingLogFileRecorder

    /**
     Initializes a new `RotatingLogFileConfiguration` instance.

     - parameter minimumSeverity: The minimum supported `LogSeverity`. Any
     `LogEntry` having a `severity` less than `minimumSeverity` will be silently
     ignored by the configuration.
     
     - parameter daysToKeep: The number of days for which log files should be
     retained.

     - parameter directoryPath: The filesystem path of the directory where the
     log files will be stored. Please note the warning above regarding the
     `directoryPath`.

     - parameter synchronousMode: Determines whether synchronous mode will be
     used by the underlying `RotatingLogFileRecorder`. Synchronous mode is
     helpful while debugging, as it ensures that logs are always up-to-date
     when debug breakpoints are hit. However, synchronous mode can have a 
     negative influence on performance and is therefore not recommended for
     use in production code.

     - parameter formatters: An array of `LogFormatter`s to use for formatting
     log entries to be recorded by the receiver. Each formatter is consulted in
     sequence, and the formatted string returned by the first formatter to
     yield a non-`nil` value will be recorded. If every formatter returns `nil`,
     the log entry is silently ignored and not recorded.

     - parameter filters: The `LogFilter`s to use when deciding whether a given
     `LogEntry` should be passed along for recording.
     */
    public init(minimumSeverity: LogSeverity, daysToKeep: Int, directoryPath: String, synchronousMode: Bool = false, formatters: [LogFormatter] = [ReadableLogFormatter()], filters: [LogFilter] = [])
    {
        logFileRecorder = RotatingLogFileRecorder(daysToKeep: daysToKeep, directoryPath: directoryPath)

        super.init(minimumSeverity: minimumSeverity, filters: filters, recorders: [logFileRecorder], synchronousMode: synchronousMode)
    }

    /**
     Attempts to create—if it does not already exist—the directory indicated
     by the `directoryPath` property.

     - throws: If the function fails to create a directory at `directoryPath`.
     */
    public func createLogDirectory()
        throws
    {
        try logFileRecorder.createLogDirectory()
    }
}
