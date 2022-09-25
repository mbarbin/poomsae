open! Core

module Kind = struct
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

let kind : t -> Kind.t = function
  | Jileugui _ -> Jileugui
  | Han_Sonnal_Mok_Tchigui _ -> Han_Sonnal_Mok_Tchigui
  | Jebipoum_Mok_Tchigui _ -> Jebipoum_Mok_Tchigui
  | Batangson_Nelyeu_Maki _ -> Batangson_Nelyeu_Maki
  | Deung_Jumok_Ap_Tchigui _ -> Deung_Jumok_Ap_Tchigui
;;
