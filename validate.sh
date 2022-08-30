#!/bin/bash

cd source
xmllint --dtdvalid  docbook/dtd/belgeler.dtd --noout belgeler.xml
cd ..
