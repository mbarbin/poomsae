open! Core

module Kind : sig
  type t =
    | Jileugui
    | Han_Sonnal_Mok_Tchigui
    | Jebipoum_Mok_Tchigui
    | Batangson_Nelyeu_Maki
    | Deung_Jumok_Ap_Tchigui
  [@@deriving equal, compare, enumerate, hash, sexp_of]
end

type t =
  | Jileugui of
      { hand : Side.t
      ; level : Level.t
      }
  | Han_Sonnal_Mok_Tchigui of { hand : Side.t }
  | Jebipoum_Mok_Tchigui of { hand : Side.t }
  | Batangson_Nelyeu_Maki of { hand : Side.t }
  | Deung_Jumok_Ap_Tchigui of
      { hand : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t
