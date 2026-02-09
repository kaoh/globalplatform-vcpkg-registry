# Summary

[vcpkg registry](https://vcpkg.io) for [GlobalPlatform library](https://github.com/kaoh/globalplatform).

# Manual Registry Version Update Instructions

__NOTE:__ The existing workflow updates the registry automatically on version updates of the GlobalPlatform library.

Update the GlobalPlatform library version:

~~~shell
nano ports/globalplatform/vcpkg.json
~~~

Set the version accordingly:

`"version": "8.0.0",`

Update the tag and set the `SHA512` to 0:

~~~shell
nano ports/globalplatform/portfile.cmake 
~~~

Set the tag:

`REF <tag>`

Copy the failed hash value from the `install` command:

~~~shell
rm ~/vcpkg/downloads/kaoh-globalplatform*
~/vcpkg/vcpkg install globalplatform --overlay-ports=./ports
~~~

You will see a message like:

> error: failing download because the expected SHA512 was all zeros, please change the expected SHA512 to: 0a66f9254390fbc27f048a76f96f9a9f858a903f55fbc67c42dd083a55b8537e6a7c436d76d67d71d327b9dd153b0832b5b46dcacce2284e9ca6bd5108d576ab

Replace the `SHA512` value:

~~~shell
nano ports/globalplatform/portfile.cmake
~~~

~~~shell
~/vcpkg/vcpkg x-add-version globalplatform --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions --overwrite-version
~~~

# Registry User Instructions

Create `vcpkg.json` in the project:

~~~json
{
  "name": "globalplatform-consumer",
  "version-string": "0.0.0",
  "dependencies": [
    "globalplatform"
  ],
  "builtin-baseline": "aa2d37682e3318d93aef87efa7b0e88e81cd3d59"
}
~~~

Create `vcpkg-configuration.json` in the project:

~~~json
{
  "registries": [
    {
      "kind": "git",
      "baseline": "fd4199d65c3dabbc653f5e741b77753252b7eab6",
      "repository": "https://github.com/kaoh/globalplatform-vcpkg-registry",
      "packages": [
        "globalplatform"
      ]
    }
  ]
}
~~~

Update `baseline`:

~~~shell
~/vcpkg/vcpkg x-update-baseline --add-initial-baseline 
~~~

Create a CMake project. Then run CMake:

~~~shell
cmake -S . -B build -G Ninja \
  -DCMAKE_MAKE_PROGRAM=/usr/bin/ninja \
  -DCMAKE_TOOLCHAIN_FILE=~/vcpkg/scripts/buildsystems/vcpkg.cmake 

cmake --build build
~~~
