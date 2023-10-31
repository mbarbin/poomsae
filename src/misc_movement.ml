module Kind = struct
  module T = struct
    type t = Bo_Joumok [@@deriving equal, compare, enumerate, hash, sexp_of]
  end

  include T
  include Comparable.Make (T)
end

type t = Bo_Joumok [@@deriving equal, compare, enumerate, hash, sexp_of]

let kind : t -> Kind.t = function
  | Bo_Joumok -> Bo_Joumok
;;

let mirror : t -> t = function
  | Bo_Joumok -> Bo_Joumok
;;
