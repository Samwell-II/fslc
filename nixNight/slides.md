# Nix Night

These slides are available along with the examples mentioned at

`https://github.com/Samwell-II/fslc`. 

> What happens when you cross theoretically awesome functional programming with your entire computer? Let's just say you might get a bit Nix'ed up. In this meeting we dive into what it means to have a truly reproducible system and leverage the power of lazy pure evaluation. We're diving head first into the Nix programming language, Nix the package manager, and NixOS itself.

---

# Nix, Nix and Nix
## At Least There's Not Six

Nix usually refers to one or multiple of
- The Nix programming language
- The Nix package manager
- The NixOS Linux distribution

---

# Timeline
## Because This All Had to Start Somewhere

Nix was created in 2003 as Eelco Dolstra's  Ph.D. thesis. I think that's an awesome Ph.D. project. He's still active and relevant to the Nix ecosystem, but less so than Linus is to Linux.

The Linux distribution didn't hit the streets until later. NixOS was hosted on a different server until 1.0 reached Github in 2012, although the internet seems sparse on detailed timelines.

---

# Nix the Programming Language
## A Functional Functional Programming Language

- Pure
- Functional
- Lazy

Data types include 'simple types' like integers, floats, strings, bools, null and paths as well as 'compound types' including lists and attribute sets.

In practice, nix looks a lot like json with functions.

---

# The Basics
## Because They're Weird

Everything is an **expression**, not a statement. Take `if` as an example. `if` ~~statements~~ expressions always need a `then` *and* `else` case. They always take the form `if ... then ... else ...`. This is because `if` allows you to choose from two expressions, as opposed to deciding whether you want to execute a statement or not.

Other syntax include `let ... in ...` expressions and `with ... ; ...` expressions.

---

# Functions
## They Put the Functional in Functional Programming

Functions!
- lambda's!
- multiple arguments
- attribute sets
- named attribute sets

The `import` function parses a nix file and returns a nix expression. It's pure, so scope is not passed while parsing the file. 

---
# So?
## "Do the Roar!" -Random Kid in Shrek

The primary purpose of the nix programming language is to create **derivations**, pure functions that outline instructions to a builder for creating files.

That's vague because derivations do a *lot*.

Remember: **Derivations are pure functions!** The same inputs (source files and dependencies) will always yield the same result.

---

# The Nix Store
## Where Nix Things Live

Derivations and their results are stored as files (simple files or directories) in the Nix Store `/nix/store/`. We don't manually change the store. It is immutible, and the system strictly protects it as a read-only filesystem.

Files in `/nix/store/` follow the naming convention `hash-name`. The hash let's us distinguish a program by more than just its semantic version!

Let's find bash!


---

# How do You Find Anything?
## How Does Anything Find Anything?

Let's look at bash again.
```
  $ ldd `which bash`
      linux-vdso.so.1 (0x00007f0d6c533000)
      libreadline.so.8 => /nix/store/8pqj80100baxyhcl9g03b7ywpj4s5mah-readline-8.3p3/lib/libreadline.so.8 (0x00007f0d6c3b4000)
      libhistory.so.8 => /nix/store/8pqj80100baxyhcl9g03b7ywpj4s5mah-readline-8.3p3/lib/libhistory.so.8 (0x00007f0d6c3a6000)
      libncursesw.so.6 => /nix/store/z2903hglhpxv4hyczli0ncdf09wmma92-ncurses-6.6/lib/libncursesw.so.6 (0x00007f0d6c32a000)
      ...
```

---

# Nix the Package Manager
## Let's Derive Greatness

- Reproduceable
- Declarative (as opposed to imperetive)

Packages are derivations. Nixpkgs is a collection of build instructions rather than binary caches, although those exist too. Actually, reproducible builds mean that copying a closure from one machine to another is guaranteed to work so caching is better than ever.

This format also makes editing and updating packages happy, even on an individual need basis. You can overide the tool chain or build inputs of a package at will.

---

# Derivations
## And How to Derive Them
At its core, every derivation comes from passing the builtin `derivation` a set with at minimum:
- `name`
- `builder`
- `system`

In general we don't declare derivations directly as in `example.nix`. Instead we use a wrapper that removes some repetition and boilerplate. `stdenv.mkDerivation` cleans things up a bit in `example2.nix` and `writeShellScript` tidies everything away in `example3.nix`.

---

# Why this is nice
## "Could you paste the results of <program you've never heard of>?"

`nix-shell` allows you to build a derivation and temporarily add it to your path in a shell. Then, if you don't like the program, you exit the shell and move on with life.

The binary is built or downloaded, and added to `/nix/store` along with all of its runtime dependencies. When you leave the shell, the binary stays in the store (until you garbage collect it). Whether you delete it or not the important thing is that there are no side effects to installing the program.

---

# NixOS
## Who Spilled Nix in My Opperating System?

Your opperating system, and all packages installed, and even your configuration files could be a package...
```
  sudo apt install myEntireSystem
```
But more... nix-like.

Simply put, derivations make files. Everything on your system (executables, directories, services, devices, even your kernel) is a file. So, with a lot of care, everything on your system can be built by derivations with all the same pure evaluation reproducibility that we promised for regular packages.

---

# Flakes!
## Wait, You Want **MORE** Reproducibility?

Derivations are pure functions evaluated against a version of `nixpkgs`, but then the version of `nixpkgs` can (does) change the produced filestructure.
- How do you keep multiple systems on the same revision of `nixpkgs`?
- What if I want to share part of a config between two systems with different pinned revisions of `nixpkgs`?

Flakes allow you to pin inputs (and specific versions of those inputs) from whatever sources you want. If you share `flake.lock` alongside `flake.nix` you are guaranteed to be building the same packages against the same input for ultimate reproducibility.

---

# Home on the Nix
## How Far Can it Go?

There's also home-manager which adds the ability for generating config files and linking to them from your home directory. Configs become part of the system derivation. Rolling back your system also rolls back your config files.

The big idea: a single `nixos-rebuild` can build your entire system from installed packages to system settings, even down to installing your custom configuration for all of those programs.

(Disclaimer: I don't use this. I tried it, and decided a two command deploy using `nixos-rebuild` and `stow` was a better fit for me.)
