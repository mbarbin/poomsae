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

type t [@@deriving enumerate, sexp_of]

val create : name:string -> Movement.t list -> t
val name : t -> string

(** The first poomses *)

val poomse_1 : t

(** Command *)

val hello_world : Sexp.t
val main : Command.t
