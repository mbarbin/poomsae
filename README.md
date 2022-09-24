# poomsae

[![Actions Status](https://github.com/mbarbin/poomsae/workflows/CI/badge.svg)](https://github.com/mbarbin/poomsae/actions/workflows/ci.yml)
[![Deploy odoc Actions Status](https://github.com/mbarbin/poomsae/workflows/Deploy-odoc/badge.svg)](https://github.com/mbarbin/poomsae/actions/workflows/deploy-odoc.yml)

This is a toy project meant to help me studying Taekwondo's poomsae.

# What's Taekwondo and what's a poomsae ?

Taekwondo is a Korean form of martial arts. See for example here:

- https://en.wikipedia.org/wiki/Taekwondo

The forms in Taekwondo are called Poomsae. They are series of
movements linked together in a prescribed sequence (like Katas for
Karate).

- https://en.wikipedia.org/wiki/Taegeuk_(taekwondo)

A lot of videos demonstrating these poomsae are available online. Here
is one of the first poomsae (Taegeuk Il Jang):

- https://www.youtube.com/watch?v=sdu8vAqdJ-k

# What's in the repo

The repo introduces utils and reprensentations that makes it possible
to encode the techniques and the consecutive movements that constitute
the Taegeuk poomsae.

The [test/](test/) directory contains a handful of statement of facts
about the poomsae and these are checked against their encoding. Below
is an example of such statement, from the first poomsae :

- all hand attacks are at the medium level (Momtong).

## Motivation

This is a personal project meant to help me studying and memorizing
the poomsae.

## Disclaimer

I don't make any claim on the correctness of the information contains
there, and make no promise that the representations that I have chosen
are truthful to actual Taekwondo's technique.

## Plans

My plan is to try and cover all 8 Taegeuk Poomsae, and fix and refine
the representations as I go along.
