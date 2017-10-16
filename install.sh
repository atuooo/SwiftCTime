#!/bin/sh
swift build -c release
cp .build/release/SwiftCTime /usr/local/bin/swiftctime
