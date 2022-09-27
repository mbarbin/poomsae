open! Core

module Kind = struct
  module T = struct
    type t =
      | Jileugui
      | Han_Sonnal_Mok_Tchigui
      | Jebipoum_Mok_Tchigui
      | Pyon_Sonn_Seo_Jileugui
      | Deung_Joumok_Ap_Tchigui
      | Me_Jumok_Nelyeu_Tchigui
    [@@deriving equal, compare, enumerate, hash, sexp_of]
  end

  include T
  include Comparable.Make_plain (T)
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

let kind : t -> Kind.t = function
  | Jileugui _ -> Jileugui
  | Han_Sonnal_Mok_Tchigui _ -> Han_Sonnal_Mok_Tchigui
  | Jebipoum_Mok_Tchigui _ -> Jebipoum_Mok_Tchigui
  | Pyon_Sonn_Seo_Jileugui _ -> Pyon_Sonn_Seo_Jileugui
  | Deung_Joumok_Ap_Tchigui _ -> Deung_Joumok_Ap_Tchigui
  | Me_Jumok_Nelyeu_Tchigui _ -> Me_Jumok_Nelyeu_Tchigui
;;

let mirror = function
  | Jileugui { hand; level } -> Jileugui { hand = Side.mirror hand; level }
  | Han_Sonnal_Mok_Tchigui { hand } -> Han_Sonnal_Mok_Tchigui { hand = Side.mirror hand }
  | Jebipoum_Mok_Tchigui { hand } -> Jebipoum_Mok_Tchigui { hand = Side.mirror hand }
  | Pyon_Sonn_Seo_Jileugui { hand } -> Pyon_Sonn_Seo_Jileugui { hand = Side.mirror hand }
  | Deung_Joumok_Ap_Tchigui { hand; level } ->
    Deung_Joumok_Ap_Tchigui { hand = Side.mirror hand; level }
  | Me_Jumok_Nelyeu_Tchigui { hand } ->
    Me_Jumok_Nelyeu_Tchigui { hand = Side.mirror hand }
;;
