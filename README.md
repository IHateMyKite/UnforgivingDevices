# UnforgivingDevices
LL link: https://www.loverslab.com/files/file/16938-unforgiving-devices/

This mod is in active development! This means every new version requires new save. Also i don't recommend using this mod for serious playthrough yet. That doesn't mean you can't enjoy this mod but just don't be disappointed if something get broken.

 
My goal with this mod is to make custom devices with custom behavior. My vision is to convert all devices from framework and give them custom behavior that will be more punishing and realistic for player. With that i mean something along this line: Gas mask will actually work like gas masks, reducing player ability to breath. Collars can choke player. Moving in restrictive boots will hurt player. Trying to swim with heavy bondage will drown player.

This are all examples of what I want to achieve in this mod (not what is currently in this mod yet).

# Documentation

I only update documentation manually once in the while, so the information on the website might not always up to date

Link: https://ihatemykite.github.io/Documentation/index.html#

Documentation can be generated locally by running [BUILDDOCU.bat](https://github.com/IHateMyKite/UnforgivingDevices/blob/main/docs/BUILDDOCU.bat) which is located in docs folder. Git is required for it to work

# Nightly build

Nightly build is created on every push to main branch. It contains all project files + compiled scripts. Intended for use by users who don't want to deal with compiling scripts. Only latest version is released. If you want to use older version, you have to find specific action and download the artifact which should also contain the zip

Link: https://github.com/IHateMyKite/UnforgivingDevices/releases/tag/NB

# Required/optional mods

Only sources are required for the UD to compile correctly. If mod is required, it means that mod is always required for mod to work correctly, otherwise the mod is optional. You still need sources of all mods, required and optional. In case there is still error when compiling scripts, it mostly means that you don't have some optional mods for DD installed. In that case, I advice you to use following tutorial (https://github.com/IHateMyKite/UnforgivingDevices/wiki/Developer-Guide#notepad) to compile scripts without needing to install the optional mods.


| **Name**                     | **Required to play?** | **LE**                                                                                                    | **SE**                                                                                                                                                          |
|------------------------------|-----------------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SexLab                       | Yes                   | https://www.loverslab.com/files/file/150-skyrim-sexlab-sex-animation-framework-v162-updated-jun-3rd-2016/ | https://www.loverslab.com/files/file/20058-sexlab-se-sex-animation-framework-v165-110822/                                                                       |
| SexLab Arousal               | Yes                   | https://www.loverslab.com/files/file/1421-sexlab-aroused-redux-december-05-2016/                          | https://www.loverslab.com/files/file/5482-sexlab-aroused-redux-sse-version-29/ or https://www.loverslab.com/files/file/20867-osl-aroused-arousal-reborn-sse-ae/ |
| Devious Devices (lates beta) | Yes                   | https://www.loverslab.com/topic/69936-devious-devices-framework-developmentbeta                           | https://www.loverslab.com/topic/69936-devious-devices-framework-developmentbeta                                                                                 |
| ConsoleUtil                  | Yes                   | https://www.nexusmods.com/skyrim/mods/66257                                                               | https://www.nexusmods.com/skyrimspecialedition/mods/24858                                                                                                       |
| SkyUi SDK                    | Yes                   | https://github.com/schlangster/skyui/wiki#skyui-sdk                                                       | https://github.com/schlangster/skyui/wiki#skyui-sdk                                                                                                             |
| UI Extensions                | Yes                   | https://www.nexusmods.com/skyrim/mods/57046                                                               | https://www.nexusmods.com/skyrimspecialedition/mods/17561                                                                                                       |
| IWantWidget                  | No                    | X                                                                                                         | https://www.nexusmods.com/skyrimspecialedition/mods/36457                                                                                                       |
| PO3 Papyrus Extender         | No                    | X                                                                                                         | https://www.nexusmods.com/skyrimspecialedition/mods/22854                                                                                                       |

# Related repositories

| **Name**            | **Author**  | **Link**                                         |
|---------------------|-------------|--------------------------------------------------|
| FOMOD               | IHateMyKite | https://github.com/IHateMyKite/UnforgivingDevices_FOMOD|
| Animation Pack [LE] | iiw2012     | https://github.com/iiw2012/UDAnimationsLE        |
| Animation Pack [SE] | iiw2012     | https://github.com/iiw2012/UDAnimationsSE        |
| Unforgiving Skyrim  | kurotatsu77 | https://github.com/kurotatsu77/UnforgivingSkyrim |

# Compiling scripts

You can compile all papyrus scripts by running [BUILD.bat](https://github.com/IHateMyKite/UnforgivingDevices/blob/main/Scripts/BUILD_ALL.bat) which is in Scripts folder. It is required that you have git installed. Will probably only work on windows. If you only want to compile single file, you can either run [BUILD_ONE.bat](https://github.com/IHateMyKite/UnforgivingDevices/blob/main/Scripts/BUILD_ONE.bat) or check my [tutorial about using notepad++](https://github.com/IHateMyKite/UnforgivingDevices/wiki/Developer-Guide#notepad)

# Development tools (WIP)
https://ihatemykite.github.io/
