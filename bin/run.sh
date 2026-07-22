#!/bin/bash

mvn versions:set -DremoveSnapshot -DgenerateBackupPoms=false -q 2>/dev/null # removing snapshot from maven version

mvn clean package -q
java -jar target/macfg-0.2.0.jar 