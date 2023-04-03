# PZ Memory Configurator

[中文版說明](README_zh-TW.md)

This small utility has the following features:
- Automatically detects the game directory and locates the ProjectZomboid64.json file
- Automatically reads the current memory settings
- Automatically detects system memory
- Automatically provides a recommended memory value (you can also enter your own)

The best part is that you don't need to install anything; it's all built-in Windows commands.

Future plans:
- Add support for different languages for international users
- Strengthen foolproof measures

Precautions:
Applicable environment:
Currently tested only on Windows 10 and Windows 11 64-bit editions, and is suitable for 64-bit systems only.
Whether it works smoothly on Windows 7 is unknown and awaits verification by someone with a Windows 7 system.
Feel free to report any issues to me.

Usage scenarios:
1. After you validate the game, the memory settings will be reset, so you need to modify them again.
2. When the game updates, it's likely to update the ProjectZomboid64.json file.
In these cases, you can open this utility and directly view the memory settings it determines for you.

License:
You are welcome to share and repost, but please credit the source.

Instructions:
Close the game first, otherwise the file cannot be modified.
1. Run PZ_Memory_Configurator.bat directly.
2. It will list your current system memory, game directory, and current memory settings for the game.
Then you only need to enter 1 or 2.

3. If you choose 2:
Just enter a number, without any extra characters. If you accidentally enter the wrong number, don't worry...
Simply re-validate the game with Steam.

Afterword:
I chose to use a .bat script to make it easy for everyone to use and to make the source code public without requiring any installations.


[![Discord](https://img.shields.io/badge/Discord-Chat-blue?style=flat-square&logo=discord)](https://discord.gg/Gur2V67)

If you have any questions or issues, feel free to open an issue on GitHub or join our [Discord server](https://discord.gg/Gur2V67) and ask for help.
