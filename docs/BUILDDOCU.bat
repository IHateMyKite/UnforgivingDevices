@echo off
if not exist "./Documentation" mkdir Documentation
cd ..
echo ===Copy paprus sources repository from GitHub===
if not exist "PAPYRUS" (echo ===Repository not present, clonning=== & git clone https://github.com/IHateMyKite/PAPYRUS & cd PAPYRUS) else (echo ===Updating papyrus script sources=== & cd PAPYRUS & git pull) 
cd "Natural Docs"
NaturalDocs.exe ../GeneratedDocu
robocopy ../GeneratedDocu/Media ../../docs/Documentation/other/Media /E /NDL /NFL /NJH /nc /ns /np
@RD /S /Q "../GeneratedDocu/Working Data"
PAUSE