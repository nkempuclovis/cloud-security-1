#!/bin/bash

for ((i=1;i<=20;i++)); do curl -I -A "User-Agent:ZyBorg/1.0" "https://www.fojilabs.com/"; done
for ((i=1;i<=20;i++)); do curl -I -A "User-Agent:PHPCrawl/1.0" "https://www.fojilabs.com/"; done
#for ((i=1;i<=200;i++)); do curl -I -A "User-Agent:Clovis-Postman" "https://www.fojilabs.com/"; done