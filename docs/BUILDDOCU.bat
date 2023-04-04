@echo off
if not exist "./Documentation" mkdir Documentation
echo **Steping to mode root directory
cd ..
echo **Checking PAPYRUS sources and tools from GitHub
if not exist "PAPYRUS" (echo **Repository not present, clonning from GitHub & git clone https://github.com/IHateMyKite/PAPYRUS & cd PAPYRUS) else (echo **PAPYRUS Folder already present, skipping... & cd PAPYRUS) 
cd "Natural Docs"
echo **Starting generation of documentation
NaturalDocs.exe ../GeneratedDocu
robocopy ../GeneratedDocu/Media ../../docs/Documentation/other/Media /E /NDL /NFL /NJH /nc /ns /np
@RD /S /Q "../GeneratedDocu/Working Data"
echo **Documentation generated!
PAUSE