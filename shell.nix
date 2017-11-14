{ pkgs ? (import <nixpkgs> {}) }:

(import ./default.nix) {
  stdenv            = pkgs.stdenv;
  fetchurl          = pkgs.fetchurl;
  curl              = pkgs.curl;
  patchelf          = pkgs.patchelf;
}
