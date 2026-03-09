#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DIST_DIR=${1:-"$ROOT_DIR/dist"}
TMP_DIR="$ROOT_DIR/.tmp-build"
MANIFEST_FILE="$TMP_DIR/manifest.txt"

cleanup() {
  rm -rf "$TMP_DIR"
}

hash_file() {
  file=$1

  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$file" | awk '{ print substr($1, 1, 12) }'
    return
  fi

  shasum -a 256 "$file" | awk '{ print substr($1, 1, 12) }'
}

escape_sed_pattern() {
  printf '%s' "$1" | sed 's/[][\\/.*^$]/\\&/g'
}

escape_sed_replacement() {
  printf '%s' "$1" | sed 's/[&|]/\\&/g'
}

copy_with_hash() {
  src_rel=$1
  src="$ROOT_DIR/$src_rel"
  dir=$(dirname "$src_rel")
  base=$(basename "$src_rel")
  name=${base%.*}
  ext=

  case "$base" in
    *.*) ext=.${base##*.} ;;
  esac

  hash=$(hash_file "$src")
  dest_rel=$dir/$name.$hash$ext

  mkdir -p "$DIST_DIR/$dir"
  cp "$src" "$DIST_DIR/$dest_rel"
  printf '%s|%s\n' "$src_rel" "$dest_rel" >> "$MANIFEST_FILE"
}

apply_manifest() {
  input_file=$1
  output_file=$2

  cp "$input_file" "$output_file"

  while IFS='|' read -r src_rel dest_rel; do
    pattern=$(escape_sed_pattern "$src_rel")
    replacement=$(escape_sed_replacement "$dest_rel")
    sed "s|$pattern|$replacement|g" "$output_file" > "$output_file.tmp"
    mv "$output_file.tmp" "$output_file"
  done < "$MANIFEST_FILE"
}

trap cleanup EXIT INT TERM

rm -rf "$DIST_DIR" "$TMP_DIR"
mkdir -p "$DIST_DIR/assets" "$TMP_DIR"
: > "$MANIFEST_FILE"

find "$ROOT_DIR/assets" -type f | LC_ALL=C sort | while read -r asset_path; do
  rel_path=${asset_path#"$ROOT_DIR"/}
  copy_with_hash "$rel_path"
done

apply_manifest "$ROOT_DIR/styles.css" "$TMP_DIR/styles.css"
styles_hash=$(hash_file "$TMP_DIR/styles.css")
styles_name=styles.$styles_hash.css
cp "$TMP_DIR/styles.css" "$DIST_DIR/$styles_name"

script_hash=$(hash_file "$ROOT_DIR/script.js")
script_name=script.$script_hash.js
cp "$ROOT_DIR/script.js" "$DIST_DIR/$script_name"

apply_manifest "$ROOT_DIR/index.html" "$TMP_DIR/index.html"
sed "s|styles.css|$styles_name|g" "$TMP_DIR/index.html" > "$TMP_DIR/index.step1.html"
sed "s|script.js|$script_name|g" "$TMP_DIR/index.step1.html" > "$DIST_DIR/index.html"

cp "$ROOT_DIR/README.md" "$DIST_DIR/README.md"

for static_file in robots.txt sitemap.xml; do
  if [ -f "$ROOT_DIR/$static_file" ]; then
    cp "$ROOT_DIR/$static_file" "$DIST_DIR/$static_file"
  fi
done
