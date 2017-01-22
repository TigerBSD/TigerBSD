#!/usr/bin/env sh

tagsuffix=$( date +%Y-%m-%d )-$( freebsd-version )-$( date +%s )

echo setup-$tagsuffix
echo src-$tagsuffix
