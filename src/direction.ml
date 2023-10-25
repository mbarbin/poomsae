open! Base

type t =
  | North
  | West
  | East
  | South
[@@deriving equal, compare, enumerate, hash, sexp_of]

module Axis = struct
  type t =
    | West_East
    | North_South
  [@@deriving equal, compare, enumerate, hash, sexp_of]
end

let axis : t -> Axis.t = function
  | North | South -> North_South
  | West | East -> West_East
;;

let group_by_axis ts =
  List.group ts ~break:(fun t1 t2 -> not (Axis.equal (axis t1) (axis t2)))
;;
