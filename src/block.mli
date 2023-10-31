(** Taekwondo blocks known as Maki are used to stop and deflect an incoming
    attack. *)

module Kind : sig
  type t =
    | Maki
    | Bakkat_Maki
    | Sonnal_Maki
    | Han_Sonnal_Maki
    | Han_Sonnal_Pitreu_Maki
    | Are_Hetcheu_Maki
    | Batangson_Maki
    | Kodeuro_Batangson_Maki
    | Kawi_Maki
    | Bakkat_Palmok_Hetcho_Maki
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  include Comparable.S with type t := t
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
  | Han_Sonnal_Maki of
      { hand : Side.t
      ; level : Level.t
      }
  | Han_Sonnal_Pitreu_Maki of
      { hand : Side.t
      ; level : Level.t
      }
  | Are_Hetcheu_Maki of { inner_hand : Side.t }
  | Batangson_Maki of
      { hand : Side.t
      ; level : Level.t
      }
  | Kodeuro_Batangson_Maki of
      { hand : Side.t
      ; level : Level.t
      }
  | Kawi_Maki
  | Bakkat_Palmok_Hetcho_Maki
[@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t

(** Reverse the hand *)
val mirror : t -> t
