open! Core

module Kind : sig
  type t =
    | Jileugui
    | Han_Sonnal_Mok_Tchigui
    | Jebipoum_Mok_Tchigui
    | Pyon_Sonn_Seo_Jileugui
    | Deung_Joumok_Ap_Tchigui
    | Me_Jumok_Nelyeu_Tchigui
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  include Comparable.S_plain with type t := t
end

type t =
  | Jileugui of
      { hand : Side.t
      ; level : Level.t
      }
  | Han_Sonnal_Mok_Tchigui of { hand : Side.t }
  | Jebipoum_Mok_Tchigui of { hand : Side.t }
  | Pyon_Sonn_Seo_Jileugui of { hand : Side.t }
  | Deung_Joumok_Ap_Tchigui of
      { hand : Side.t
      ; level : Level.t
      }
  | Me_Jumok_Nelyeu_Tchigui of { hand : Side.t }
[@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t

(** Changes the hand *)
val mirror : t -> t
