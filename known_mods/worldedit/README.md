
WorldEdit
=========

Current status:

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

