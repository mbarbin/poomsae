open! Core

(** Taekwondo blocks known as Maki are used to stop and deflect an
    incoming attack. *)

type t =
  | Maki of
      { hand : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]
