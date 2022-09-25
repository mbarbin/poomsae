open! Core
module Block = Block
module Direction = Direction
module Elements = Elements
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

(** Utils on poomsae *)

val elements : t -> Elements.t

(** Poomsaes are designed so that one returns to the original position at
   the end of all combined displacements. *)
val displacement_returns_to_origin : t -> unit Or_error.t

val iter_consecutive_movements : t -> f:(Movement.t -> Movement.t -> unit) -> unit

(** The first 8 poomsaes. *)

val poomsae_1 : t
val poomsae_2 : t
val poomsae_3 : t
val poomsae_4 : t
val poomsae_5 : t
val poomsae_6 : t
val poomsae_7 : t
val poomsae_8 : t

(** All poomsaes *)
val all : t list

(** Return all poomsae that are located in [all] prior to the given
   poomsae. Only works with poomsae that are physically equal to one
   of [poomsae_1-8]. *)
val preceding_poomsaes : t -> t list

(** Return only the elements that are new compared to the
   accumultation of elements of the preceding poomsaes. *)
val new_elements : t -> Elements.t

(** Command *)

val hello_world : Sexp.t
val main : Command.t
