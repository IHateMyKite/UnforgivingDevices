@echo off

echo **Copy UI to PrismaUI folder
rmdir /s /q "PrismaUI"
xcopy "UD/UI" "PrismaUI/views/UnforgivingDevices/*" /s /e /Y /D

echo **Copy UI to Magelight folder
rmdir /s /q "Magelight"
xcopy "UD/UI" "Magelight/UnforgivingDevices/*" /s /e /Y /D