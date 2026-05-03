# tech_context

## Engine
- **Unity 6000.0.32f1 LTS** (pinned in `ProjectSettings/ProjectVersion.txt`). Do not bump without team agreement — shader graph behavior changed in 6000.0.28.
- Render pipeline: URP 17.0.x.
- Input: Input System 1.8 (new), not legacy Input Manager.

## Packages
- Mirror 89.x (see decisions.md re: choice over Netcode for GameObjects).
- Addressables 2.2.
- Cinemachine 3.1.
- UI Toolkit (built-in).
- Steamworks.NET 20.2.

## Build
```
# Local dev build (Editor batch mode)
Unity.exe -batchmode -nographics -quit -projectPath . \
  -executeMethod Game.Editor.BuildPipeline.BuildWindowsDev \
  -logFile build.log

# Release build
Unity.exe -batchmode -nographics -quit -projectPath . \
  -executeMethod Game.Editor.BuildPipeline.BuildWindowsRelease \
  -logFile build.log
```
- IL2CPP backend, .NET Standard 2.1 API compat.
- Architecture: Windows x64 only at v1.
- Stripping: Low (Medium breaks Mirror reflection-based serializer in spots).
- Managed debugging off in release.

## Steam upload
```
steamcmd +login <builder> +run_app_build ../steam/app_build_voidrun.vdf +quit
```
App build VDF lives in `tools/steam/`. Branches: `default`, `beta`, `internal`.

## CI
GitHub Actions self-hosted runner (Unity license requires it). Runs editmode tests on PR, full build + playmode tests nightly on `main`.
