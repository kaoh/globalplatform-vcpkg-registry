# Summary

[vcpkg registry](https://vcpkg.io) for [GlobalPlatform library](https://github.com/kaoh/globalplatform).

# Version Update

Update the GlobalPlatform library version:

~~~shell
nano ports/globalplatform/vcpkg.json
~~~

Set the version accordingly:

`"version-string": "8.0.0",`

Update the tag and set the `SHA512` to 0:

~~~shell
nano ports/globalplatform/portfile.cmake 
~~~

Set the tag:

`REF <tag>`

Copy the failed hash value from the `install` command:

~~~shell
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
