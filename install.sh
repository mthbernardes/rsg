#!/bin/bash

pip install -r dependencies.txt
ln -s $(pwd)/rsg /usr/local/bin
rsg
