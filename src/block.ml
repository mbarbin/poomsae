module Kind = struct
  module T = struct
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
  end

  include T
  include Comparable.Make (T)
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

let kind : t -> Kind.t = function
  | Maki _ -> Maki
  | Bakkat_Maki _ -> Bakkat_Maki
  | Sonnal_Maki _ -> Sonnal_Maki
  | Han_Sonnal_Maki _ -> Han_Sonnal_Maki
  | Han_Sonnal_Pitreu_Maki _ -> Han_Sonnal_Pitreu_Maki
  | Are_Hetcheu_Maki _ -> Are_Hetcheu_Maki
  | Batangson_Maki _ -> Batangson_Maki
  | Kodeuro_Batangson_Maki _ -> Kodeuro_Batangson_Maki
  | Kawi_Maki -> Kawi_Maki
  | Bakkat_Palmok_Hetcho_Maki -> Bakkat_Palmok_Hetcho_Maki
;;

let mirror = function
  | Maki { hand; level } -> Maki { hand = Side.mirror hand; level }
  | Bakkat_Maki { hand; level } -> Bakkat_Maki { hand = Side.mirror hand; level }
  | Sonnal_Maki { hand; level } -> Sonnal_Maki { hand = Side.mirror hand; level }
  | Han_Sonnal_Maki { hand; level } -> Han_Sonnal_Maki { hand = Side.mirror hand; level }
  | Han_Sonnal_Pitreu_Maki { hand; level } ->
    Han_Sonnal_Pitreu_Maki { hand = Side.mirror hand; level }
  | Are_Hetcheu_Maki { inner_hand } ->
    Are_Hetcheu_Maki { inner_hand = Side.mirror inner_hand }
  | Batangson_Maki { hand; level } -> Batangson_Maki { hand = Side.mirror hand; level }
  | Kodeuro_Batangson_Maki { hand; level } ->
    Kodeuro_Batangson_Maki { hand = Side.mirror hand; level }
  | Kawi_Maki -> Kawi_Maki
  | Bakkat_Palmok_Hetcho_Maki -> Bakkat_Palmok_Hetcho_Maki
;;
