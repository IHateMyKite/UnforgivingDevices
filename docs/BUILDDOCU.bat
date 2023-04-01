if not exist "Documentation" mkdir Documentation
cd ..
git clone --quiet https://github.com/IHateMyKite/PAPYRUS
cd PAPYRUS
git pull
cd "Natural Docs"
NaturalDocs.exe ../GeneratedDocu
robocopy ../GeneratedDocu/Media ../../docs/Documentation/other/Media /E /NDL /NFL /NJH /nc /ns /np
cd ..
@RD /S /Q "./GeneratedDocu/Working Data"
cd ..
REM @RD /S /Q "./PAPYRUS"
PAUSE