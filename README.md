# FrameCore Engine

**FrameCore Engine** is a feature-rich and optimized Friday Night Funkin' engine based on **Psych Engine 1.0.4**.

FrameCore is designed for mod developers who want a familiar Psych Engine workflow while having additional tools, visual features, performance improvements, and quality-of-life changes.

The goal of FrameCore is to provide a solid and flexible foundation for creating, testing, and playing Friday Night Funkin' mods without unnecessarily changing the workflow that Psych Engine users are already familiar with.

---

## Modding

FrameCore is designed to provide a familiar workflow for Friday Night Funkin' mod development.

Developers can work with:

* Source code
* Lua scripts
* HScript
* Custom assets
* Characters
* Stages
* Weeks
* Charts
* Dialogue
* Custom gameplay systems

Advanced developers can modify the engine's source code directly and compile their own builds.

---

## Building From Source

### Requirements

FrameCore uses the Haxe ecosystem and the technologies used by Psych Engine.

You will need:

* Haxe
* HaxeFlixel
* Lime
* Required Haxelib dependencies
* Java JDK for Android builds
* A supported development environment

### Clone the repository

```bash
git clone https://github.com/ArngMods93/FrameCore-Engine.git
cd FrameCore-Engine
```

Install the required dependencies and configure your Haxe/Lime environment.

### Compile

For example, to compile the Windows version:

```bash
lime test windows
```

Other targets can be compiled using the corresponding Lime target.

---

## Philosophy

FrameCore is built around three main principles:

### Familiar

Keep the Psych Engine workflow recognizable so existing Psych Engine developers can work with FrameCore without having to relearn the entire engine.

### Optimized

Improve performance and reduce unnecessary overhead while maintaining the features and flexibility expected from a modern FNF engine.

### Expandable

Provide a solid foundation that can be extended with new features, tools, editors, and improvements over time.

FrameCore is not intended to completely reinvent Psych Engine. It builds upon its existing foundation while developing its own direction and feature set.
