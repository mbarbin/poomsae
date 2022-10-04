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
      | Palkoup_Dolyeu_Tchigui
      | Palkoup_Pyo_Jeuk_Tchigui
      | Kodeuro_Deung_Joumok_Ap_Tchigui
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
  | Palkoup_Dolyeu_Tchigui of { elbow : Side.t }
  | Palkoup_Pyo_Jeuk_Tchigui of { elbow : Side.t }
  | Kodeuro_Deung_Joumok_Ap_Tchigui of
      { hand : Side.t
      ; level : Level.t
      }
[@@deriving equal, compare, enumerate, hash, sexp_of]

let kind : t -> Kind.t = function
  | Jileugui _ -> Jileugui
  | Han_Sonnal_Mok_Tchigui _ -> Han_Sonnal_Mok_Tchigui
  | Jebipoum_Mok_Tchigui _ -> Jebipoum_Mok_Tchigui
  | Pyon_Sonn_Seo_Jileugui _ -> Pyon_Sonn_Seo_Jileugui
  | Deung_Joumok_Ap_Tchigui _ -> Deung_Joumok_Ap_Tchigui
  | Me_Jumok_Nelyeu_Tchigui _ -> Me_Jumok_Nelyeu_Tchigui
  | Palkoup_Dolyeu_Tchigui _ -> Palkoup_Dolyeu_Tchigui
  | Palkoup_Pyo_Jeuk_Tchigui _ -> Palkoup_Pyo_Jeuk_Tchigui
  | Kodeuro_Deung_Joumok_Ap_Tchigui _ -> Kodeuro_Deung_Joumok_Ap_Tchigui
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
  | Palkoup_Dolyeu_Tchigui { elbow } ->
    Palkoup_Dolyeu_Tchigui { elbow = Side.mirror elbow }
  | Palkoup_Pyo_Jeuk_Tchigui { elbow } ->
    Palkoup_Pyo_Jeuk_Tchigui { elbow = Side.mirror elbow }
  | Kodeuro_Deung_Joumok_Ap_Tchigui { hand; level } ->
    Kodeuro_Deung_Joumok_Ap_Tchigui { hand = Side.mirror hand; level }
;;
