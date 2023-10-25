open! Base

module Kind : sig
  type t =
    | Jileugui
    | Han_Sonnal_Mok_Tchigui
    | Jebipoum_Mok_Tchigui
    | Pyon_Sonn_Seo_Jileugui
    | Deung_Joumok_Ap_Tchigui
    | Me_Jumok_Nelyeu_Tchigui
    | Palkoup_Dolyeu_Tchigui
    | Palkoup_Pyo_Jeuk_Tchigui
    | Kodeuro_Deung_Joumok_Ap_Tchigui
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  include Comparable.S with type t := t
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
  | Palkoup_Dolyeu_Tchigui of { elbow : Side.t }
  | Palkoup_Pyo_Jeuk_Tchigui of { elbow : Side.t }
  | Kodeuro_Deung_Joumok_Ap_Tchigui of
      { hand : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]

val kind : t -> Kind.t

(** Changes the hand *)
val mirror : t -> t
