open! Core

(** Taekwondo blocks known as Maki are used to stop and deflect an
    incoming attack. *)

module Kind : sig
  type t =
    | Maki
    | Bakkat_Maki
    | Sonnal_Maki
    | Han_Sonnal_Bakkat_Maki
  [@@deriving equal, compare, enumerate, hash, sexp_of]
end

type t =
  | Maki of
      { hand : Side.t
      ; level : Level.t
      }
  | Bakkat_Maki of
      { hand : Side.t
      ; level : Level.t
      }
  | Sonnal_Maki of
      { hand : Side.t
      ; level : Level.t
      }
  | Han_Sonnal_Bakkat_Maki of
      { hand : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t
