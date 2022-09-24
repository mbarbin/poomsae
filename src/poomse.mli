open! Core
module Block = Block
module Direction = Direction
module Hand_attack = Hand_attack
module Kick = Kick
module Level = Level
module Movement = Movement
module Position = Position
module Side = Side
module Technique = Technique

type t [@@deriving sexp_of]

val create : name:string -> Movement.t list -> t
val name : t -> string
val movements : t -> Movement.t list

(** Utils on poomse *)

(** Poomse is designed so that one returns to the original position at
   the end of all combined displacements. *)
val displacement_returns_to_origin : t -> unit Or_error.t

val iter_consecutive_movements : t -> f:(Movement.t -> Movement.t -> unit) -> unit

(** The first poomses *)

val poomse_1 : t

(** All poomse *)

val all : t list

(** Command *)

val hello_world : Sexp.t
val main : Command.t
