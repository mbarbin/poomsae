open! Core

let all_of_list _ = []
let all = []

type t =
  | Block of Block.t
  | Hand_attack of Hand_attack.t
  | Kick of Kick.t
  | Linked of t list
[@@deriving equal, compare, enumerate, hash, sexp_of]
