cd ..
if not exist "PAPYRUS" git clone https://github.com/IHateMyKite/PAPYRUS
cd PAPYRUS
git pull
BUILD
cd ..
REM @RD /S /Q "./PAPYRUS"
PAUSE