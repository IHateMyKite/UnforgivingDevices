@echo off
cd ..
echo ===Copy paprus sources repository from GitHub===
if not exist "PAPYRUS" (echo ===Repository not present, clonning=== & git clone https://github.com/IHateMyKite/PAPYRUS) else (echo ===Updating papyrus script sources=== & git pull) 
cd PAPYRUS
BUILD_SINGLE & PAUSE
