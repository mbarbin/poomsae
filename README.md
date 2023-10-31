# poomsae

[![CI Status](https://github.com/mbarbin/poomsae/workflows/ci/badge.svg)](https://github.com/mbarbin/poomsae/actions/workflows/ci.yml)
[![Deploy odoc Status](https://github.com/mbarbin/poomsae/workflows/deploy-odoc/badge.svg)](https://github.com/mbarbin/poomsae/actions/workflows/deploy-odoc.yml)

This is a toy project meant to help me studying Taekwondo's poomsaes.

# What's Taekwondo and what's a poomsae ?

Taekwondo is a Korean form of martial arts. See for example here:

- https://en.wikipedia.org/wiki/Taekwondo

The forms in Taekwondo are called Poomsaes. They are series of
movements linked together in a prescribed sequence (like Katas for
Karate).

- https://en.wikipedia.org/wiki/Taegeuk_(taekwondo)

A lot of videos demonstrating these poomsaes are available online. Here
is one of the first poomsae (Taegeuk Il Jang):

- https://www.youtube.com/watch?v=sdu8vAqdJ-k

# What's in the repo

The repo introduces utils and reprensentations that makes it possible
to encode the techniques and the consecutive movements that constitute
the Taegeuk poomsaes.

The [test/](test/) directory contains a handful of statement of facts
about the poomsaes which are checked against their encoding. Here is
an example of such statement: "In the first poomsae, all hand attacks
are at the medium level (Momtong)".

## Motivation

This is a personal project meant to help me studying and memorizing
the poomsaes.

## Disclaimer

I don't make any claims regarding the correctness of the information
contains here, and make no promise that the representations that I
have chosen are truthful to actual Taekwondo's technique.

## Plans

My plan is to try and cover all 8 Taegeuk poomsaes, and fix and refine
the representations as I go along to make that possible.

## Code documentation

The tip of the main branch is compiled with odoc and published to
github pages [here](https://mbarbin.github.io/poomsae/).

## Acknowledgements

I have referred to online resources made available by the French
Federation of Taekwondo, which helped me a great deal:

- https://www.fftda.fr/

Being able to look at demo videos online is quite helpful too, such as
the one I mentioned in the introduction. A few others I've looked at:

- https://www.youtube.com/watch?v=FD1yQP_o5Bs
- https://www.youtube.com/watch?v=j8ee61tXa2s
