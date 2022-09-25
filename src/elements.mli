open! Core

type t =
  { positions : Set.M(Position.Kind).t
  ; blocks : Set.M(Block.Kind).t
  ; hand_attacks : Set.M(Hand_attack.Kind).t
  ; kicks : Set.M(Kick.Kind).t
  }
[@@deriving sexp_of]

val empty : t
val add_movement : t -> Movement.t -> t
val union : t -> t -> t
val diff : t -> t -> t
