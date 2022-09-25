open! Core

module Kind = struct
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

let kind : t -> Kind.t = function
  | Maki _ -> Maki
  | Bakkat_Maki _ -> Bakkat_Maki
  | Sonnal_Maki _ -> Sonnal_Maki
  | Han_Sonnal_Bakkat_Maki _ -> Han_Sonnal_Bakkat_Maki
;;
