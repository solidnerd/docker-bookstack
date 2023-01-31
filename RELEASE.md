# Making a release

When the version changes, a new release should be cut. To do this, push a tag
with the [valid SemVer][semver-checker] version number as the tag.
It may also be useful to update documentation references at the same time.

## Example

For Bookstack version 23.01:

```shell
sed -i '' -e 's/22.11.1/23.1.0/g' *     # 22.11.1 was the previous version
git commit -am "Update references to version 23.1.0" [-S]
git tag [-s] -a 23.1.0 -m "Release version 23.01"
git push --tags
```

The workflow will then build, test, push, and release this image.

[semver-checker]: https://jubianchi.github.io/semver-check/
