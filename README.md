
<!--#echo json="package.json" key="name" underline="=" -->
minecraft-uncurse-mods
======================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Trying to provide FOSS-friendly download options for lots Minecraft mods
currently imprisoned on CurseForge.
<!--/#echo -->



Motivation
----------

I was trying to simplify downloading a lot of the mods that I like to use.
[MultiMC should have been able to do it
](https://github.com/MultiMC/Launcher/issues/5134)
but unfortunately
[CurseForge's TOS seem to be hostile towards free software.
](https://github.com/MultiMC/Launcher/issues/4762)
CurseForge seems to also hate me, or rather, to be too afraid of me
for my privacy choices.
Fortunately, most of the mods that I'm interested in are free software,
so I should be able to provide them independently from CurseForge.
Let's lift that curse.



Bonus features
--------------

* [ ] A downloader that not only grabs JARs but also…
  * [ ] renames them in a way that lets me find compatible JARs easily in
        MultiMC's file selection dialog.
  * [ ] rewrites them locally to normalize the declared mod version in a way
        that lets me easily verify versions in MultiMC's instance mod list.



Mods currently in scope
-----------------------

### Good enough

* [WorldEdit](known_mods/worldedit/)
* [WorldEdit CUI](known_mods/worldeditcui/)

### Upcoming

* https://github.com/Rakambda/EditSign
* https://github.com/badasintended/wthit
  * [needs](https://github.com/badasintended/wthit/blob/4cafc52a34d1726ec324ff393c9b6f197c7a96d0/docs/plugin/getting_started.md?plain=1#L22)
    https://github.com/badasintended/badpackets
* https://github.com/LambdAurora/LambDynamicLights
* https://github.com/LambdAurora/LambdaBetterGrass
* https://github.com/Siphalor/mouse-wheelie
* https://github.com/Rakambda/FallingTree
* https://github.com/Rongmario/CleanCut
* https://github.com/maruohon/minihud
  * [needs](https://github.com/maruohon/minihud/blob/b6e5d670fe6a2dd5ef86d964830b12beed5686ae/README.md?plain=1#L18)
    https://github.com/maruohon/malilib
* https://github.com/shedaniel/RoughlyEnoughItems
* https://github.com/squeek502/AppleSkin
* https://github.com/Wurst-Imperium/WI-Zoom
* https://github.com/isXander/Zoomify
* https://github.com/Szum123321/window_title_changer
* <del>Xaero's Minimap + WorldMap</del> (not free software, unfortunately.)


### Performance mods

* Packs
  * https://github.com/TherionRO/Minecraft-Optimization-Pack
  * https://github.com/auroric-platform/fabric-mods
* https://github.com/PaperMC/Starlight
* iris
* https://github.com/CaffeineMC/sodium-fabric
* https://github.com/rfresh2/XaeroPlus


### Maybe unidentified deps of other mods?
* architectury
* cloth-config
* continuity
* clumps
* entityculling
* ferritecore
* FpsReducer2
* indium
* lazydfu
* lithium
* modmenu
* viafabric


### Maybe later
* dark-loading-screen (obsolete in MC 1.19.4+, replaced by Vanilla
  accessibility option, also can probably be fixed via resource pack.)
* betterbeds
* horse-stats-vanilla
* window_title_changer
* [Open Parties and Claims](https://github.com/thexaero/open-parties-and-claims)
* [OpenBlocks](https://github.com/OpenMods/OpenBlocks)

* Lists of mod suggestions:
  * https://github.com/babybluetit/Xaeros-Minimap-Modded-Support
  * https://legacy.curseforge.com/minecraft/modpacks/lazarvanilla
  * https://legacy.curseforge.com/minecraft/modpacks/untold-stories






<!--#toc stop="scan" -->



Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
