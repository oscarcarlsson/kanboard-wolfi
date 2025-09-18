This is an experiment with the end goal of running [kanboard][kanboard] using 
[wolfi-php][wolfi-php] as a base container, which in turn is using 
[wolfi][wolfi] as a base.

## Why?

The current kanboard docker container requires excessive permissions and
capabilities to function.  The container runs as root before starting
child processes as other users, and it also runs a `chown` in it's 
entrypoint script -- and both of these becomes an issue if you want to run
kanboard in a restricted environment (like RKE2/Talos).

My first idea was to try to fix this in the upstream `Dockerfile`, but that
will most likely cause breaking changes for most current users.

## How?

- Rebuild on [wolfi-php][wolfi-php]
- Use docker volumes instead of bind-mounts
- ???
- Profit!

## Status

As of 2025-09-18, this repository will run a weekly rebuild of the latest 
released version of Kanboard.  This rebuild will be published under the 
`latest` and the Kanboard version (currently v1.2.47) as a tag.

## Future

Future plans involve:

- [ ] Matrix building the three latest Kanboard versions
- [ ] x86 and aarch64
- [ ] Dogfooding / using it myself
- [ ] Automate adding new Kanboard releases

[kanboard]: https://kanboard.org/
[kanboard-repo]: https://github.com/kanboard/kanboard/
[wolfi-php]: https://github.com/shyim/wolfi-php/
[wolfi]: https://github.com/wolfi-dev/os
