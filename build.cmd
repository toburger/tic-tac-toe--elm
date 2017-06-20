@echo off
elm make .\Main.elm --output App.js
uglifyjs App.js -m -c --output App.min.js