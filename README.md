# FNF Multikey (Funkin-Multikey)

![Logo](art/krita/FNF%20Multikey%20Logo.png)

A Simple engine made with a [Week 7 Source Reverse Engineering](https://github.com/AngelDTF/FNF-NewgroundsPort) that adds mod support, extra settings, and multi-key (not done yet in week-7-engine/main branch lmao).

That's pretty much it.

# Building the game

Step 1. [Install Haxe](https://haxe.org/download/)
Step 2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)

Step 3. Run these commands to install the libraries required:
```
haxelib install flixel
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install polymod
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git openfl https://github.com/openfl/openfl
```

Step 4 (Windows only). Install Visual Studio Community 2019, and while installing instead of selecting the normal options, only select these components in the 'individual components' instead (or things named very similar)
```
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)
```

Step 5. Run `lime test [operating system goes here]` in the project directory while replacing '[operating system goes here]' with your build type (usually `windows`, `linux`, `mac`, etc).