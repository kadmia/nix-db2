{ pkgs ? (import <nixpkgs> {}) }:

(import ./default.nix) {
  stdenv            = pkgs.stdenv;
  fetchurl          = pkgs.fetchurl;
  patchelf          = pkgs.patchelf;
  pam               = pkgs.pam;
}
