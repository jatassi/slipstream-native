#!/bin/sh
# Publishes each layer of the CI matrix in $MATRIX, read from assets/, as the
# single asset of its own release. A published layer never changes, so a tag
# that already exists is left alone.
set -eu
echo "$MATRIX" | jq -c '.include[]' | while read -r layer; do
	tag=$(echo "$layer" | jq -r .tag)
	asset=$(echo "$layer" | jq -r .asset)
	if gh release view "$tag" -R "$GITHUB_REPOSITORY" > /dev/null 2>&1; then
		echo "$tag is already published; a published layer never changes"
		continue
	fi
	gh release create "$tag" "assets/$asset" -R "$GITHUB_REPOSITORY" \
		--prerelease --latest=false --title "$tag" \
		--notes "$(echo "$layer" | jq -r .target) layer built from jatassi/SlipStream@$REF"
done
