
WorldEdit
=========

<!-- %begin% descr -->
In-game map editor, providing mass-operations on blocks and lots more.
<!-- %endof% descr -->

<!-- %begin% meta -->

* __Mod repo:__
  https://github.com/EngineHub/WorldEdit

* __Official download site:__
  https://www.curseforge.com/minecraft/mc-mods/worldedit
  * If the official download site works for you, please download from there,
    so the mod authors get proper statistics on the populariy of their mod.

<!-- %endof% meta -->


Current status
--------------

* [Compatibility overview](compat_versions.txt):
  Which WorldEdit version do you need for which Minecraft version?
* For the main WorldEdit mod, the [Fabric CI artifacts](fabric_ci_artifacts.md)
  work good enough for me.
* For WorldEdit CUI,
  [the GitHub releases](https://github.com/EngineHub/WorldEditCUI/releases)
  work good enough for me.

If you'd like to have uncursed downloads for other versions,
please open an issue and we will figure something out.
After all, WorldEdit seems to be built on GitHub Actions, albeit the
resulting binaries seem to be discarded. It should be rather easy to
remix that CI workflow with the one from the CUI in order to have it
produce releases with JAR files.
Or we could just have GitHub Actions upload them as artifacts and
persist them in the Wayback Machine.

