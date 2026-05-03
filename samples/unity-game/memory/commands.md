# commands

## Editor
```
# Open project
Unity.exe -projectPath .

# Run editmode tests
Unity.exe -batchmode -runTests -testPlatform editmode -projectPath . -logFile -

# Run playmode tests
Unity.exe -batchmode -runTests -testPlatform playmode -projectPath . -logFile -
```

## Build
```
# Dev (debug symbols, profiler-enabled)
Unity.exe -batchmode -nographics -quit -projectPath . \
  -executeMethod Game.Editor.BuildPipeline.BuildWindowsDev -logFile build.log

# Release
Unity.exe -batchmode -nographics -quit -projectPath . \
  -executeMethod Game.Editor.BuildPipeline.BuildWindowsRelease -logFile build.log
```

## Addressables
```
# Build content
Unity.exe -batchmode -nographics -quit -projectPath . \
  -executeMethod Game.Editor.AddressablesBuild.BuildContent

# Update existing content (delta)
... -executeMethod Game.Editor.AddressablesBuild.UpdateContent
```

## Steam
```
steamcmd +login <builder> +run_app_build tools/steam/app_build_voidrun.vdf +quit
```

## Profiling
```
# Attach to running editor or player via Unity Profiler GUI.
# Headless deep-profile run (4p bot stress):
Unity.exe -batchmode -nographics -projectPath . \
  -executeMethod Game.Editor.StressTest.RunFourPlayerBots -profile -logFile stress.log
```
