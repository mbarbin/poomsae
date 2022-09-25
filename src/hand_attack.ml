open! Core

type t =
  | Jileugui of
      { hand : Side.t
      ; level : Level.t
      }
  | Han_Sonnal_Mok_Tchigui of { hand : Side.t }
  | Jepiboum_Mok_Tchigui of { hand : Side.t }
  | Batanson_Neulou_Maki of { hand : Side.t }
  | Dung_Joumok_Ap_Tchigui of
      { hand : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]
