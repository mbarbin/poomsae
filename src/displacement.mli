open! Core

(** This type is used to calculate the movement of the performer relative to the
    starting point (origin) of the poomsae, in the 2 dimensional space that it
    occupies while performing the poomsae.

    Poomsae are designed such that the performer is expected to arrive at the
    point of origin upon completing the sequence of movements. This module helps
    in verifying that particular design characteristic. *)

type t [@@deriving equal, sexp_of]

(** The point where the poomsae start (and must end). *)
val origin : t

(** Account for a move and update the displacement accordingly. *)
val move : t -> Movement.t -> t
