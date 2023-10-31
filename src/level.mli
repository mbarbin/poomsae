(** Levels are used to characterize the targeting area of an attack. The three
    known levels are low (feet), medium (body) and high (head). When used to
    characterize blocks, levels indicate the level of the attack that the
    block is deflecting. *)

type t =
  | Ale (** Low *)
  | Montong (** Medium *)
  | Eulgoul (** High *)
[@@deriving equal, compare, enumerate, hash, sexp_of]
