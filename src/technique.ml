open! Core

let all_of_list _ = []
let all = []

type t =
  | Block of Block.t
  | Hand_attack of Hand_attack.t
  | Kick of Kick.t
  | Chained of t list
[@@deriving equal, compare, enumerate, hash, sexp_of]

let rec iter t ~f =
  match (t : t) with
  | (Block _ | Hand_attack _ | Kick _) as t -> f t
  | Chained ts -> List.iter ts ~f:(fun t -> iter t ~f)
;;

let rec fold t ~init ~f =
  match (t : t) with
  | (Block _ | Hand_attack _ | Kick _) as t -> f init t
  | Chained ts -> List.fold ts ~init ~f:(fun acc t -> fold t ~init:acc ~f)
;;

let rec mirror = function
  | Block x -> Block (Block.mirror x)
  | Hand_attack x -> Hand_attack (Hand_attack.mirror x)
  | Kick x -> Kick (Kick.mirror x)
  | Chained ts -> Chained (List.map ts ~f:mirror)
;;
