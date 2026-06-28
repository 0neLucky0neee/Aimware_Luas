# Quick Lua bookmarks
* [**1. Reconnect Bypass**](#Reconnect-Bypass)
* * [**Updates**](#Reconnect-Bypass-Updates)
* [**2. Name Changer**](#Name-Changer)
* * [**Updates**](#Name-Changer-Updates)

# Reconnect Bypass
A lua script designed to allow you to reconnect after getting kicked and to prevent griefing cooldowns.

![Preview_Reconnect_Bypass](https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Reconnect%20Bypass/Assets/preview.png)

## How to use
Follow these steps:

​**Note for tweaked OS users:** If you are using a tweaked OS, follow the steps up to #4, launch the script, wait 10 seconds, and reboot.

1. **Enable FFI:** Make sure you turned on "Allow insecure FFI" option, as shown below:
![Image](https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Reconnect%20Bypass/Assets/LuaSecurity.png)
2. **Load the script**
3. **Grant admin rights** (required for the firewall changes)
![Image_2](https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Reconnect%20Bypass/Assets/PowerShell_UAC.png)
4. **Make sure it loads properly**
   * Press the **"Disable"** button
   * If status changes from **"Unknown"**, script was loaded correctly
   * If not, simply reload one more time
5. **Join any match**
6. **Activate when needed:** as soon as votekick starts against you, press **"Enable"** button
7. **Done, now you can rejoin the match even after votekick**

# Reconnect Bypass Updates

**[UPDATE V1.7.2] 27.06**
- It is preferably, but no longer necessary to press the **"Disable"** button at startup

**[UPDATE V1.7.1] 25.06**
- Hotfix

**[UPDATE V1.7.0] 25.06**
- Improved stability
- Better version management

**[UPDATE V1.6] 25.06**
- Big improvements.
- Staring from now: the script will be loading on the first attempt.

**[UPDATE V1.5] 20.06**
- Small improvements.

**[UPDATE V1.4] 16.06**
- Fixed an issue that may cause a crash when the network connection was unstable.

**[UPDATE V1.3] 14.06**
- The script now **automatically** enables Windows Firewall before applying changes. If it failed to work previously, or if you are using a tweaked OS, launch the script, wait 10 seconds and reboot.
- Fixed an issue preventing the menu from closing if you had a different keybind for it.

### Video Demonstration
[![Watch the video](https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Reconnect%20Bypass/Assets/Video-Preview.png)](https://youtu.be/YLrvdHOrXCM)

# Name Changer
A lua script designed to allow you to change your clan-tag by manipulating the "name" ConVar.
In addition, it features an option to disappear from radars.

![Preview_Name_Changer](https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Name%20Changer/Assets/preview.png)

## How to use
Follow these steps:

1. **Enable FFI:** Make sure you turned on "Allow insecure FFI" option, as shown below:
![Image](https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Name%20Changer/Assets/LuaSecurity.png)
2. **Join any match**
3. **Load the script**
4. **Choose the option:**
   * **Misc** -> **Features** -> **Clan-tag/Name-tag**
5. **Done! The clan-tag will be applied**

# Name Changer Updates

**[UPDATE V1.4.0] 28.06**
- Added an "Animated" option
- Fixed a crash that may occur _randomly_ with "Minecraft" option
- Fixed a crash that may occur when changing maps

**[UPDATE V1.3.7] 25.06**
- Logic changes
- Fixed all possible issues
- Fixed a crash that occurred when changing maps
- Fixed clan-tag not applying after a map change

**[UPDATE V1.3.5] 25.06**
- Another Hotfix
- Sometimes on reloading cfg username was not restored correctly

**[UPDATE V1.3.4] 25.06**
- Hotfix

**[UPDATE V1.3.3] 25.06**
- Improved stability
- Better version management
- Clan-tag/Name-tag will be applied even if a character not alive

**[UPDATE V1.3] 25.06**
- Added a "Fake name" option
- Small improvements

### Video Demonstration
[![Watch the video](https://raw.githubusercontent.com/0neLucky0neee/Aimware_Luas/refs/heads/main/Name%20Changer/Assets/Video-Preview.png)](https://youtu.be/zgc45_dN5yI)
