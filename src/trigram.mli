open! Core

(** Trigrams are symbols constituted by 3 horizontal lines which may
    each be broken down into two parts.

    Some examples:

    {[
      --  --
      ------
      ------
    ]}

    {[
      --  --
      ------
      --  --
    ]}

    Because there are 3 lines with 2 possible choices per line (plain,
    or broken down into two parts), it follows that there are 8
    different trigrams in total. *)

module Line_kind : sig
  type t =
    | Plain
    | Two_parts
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  val to_string : t -> string
end

type t =
  { top_line : Line_kind.t
  ; middle_line : Line_kind.t
  ; bottom_line : Line_kind.t
  }
[@@deriving equal, compare, enumerate, hash, sexp_of]

(** Return the index represented by the trigram, between 1 and 8. *)
val index : t -> int

val top_down_line_kinds : t -> Line_kind.t list

(** Build a human representation of the trigram for printing in unit
    test. To be printed at the same alignement. Example of lines:

    {[
      [ "--  --"; "------"; "--  --" ]
    ]}

    which would render as:

    {[
      --  --
      ------
      --  --
    ]} *)
val top_down_lines : t -> string list

(** Try and recompute what is the trigram that matches a given
    sequence of movements, if any. This is used in tests to understand
    the logic by which each poomsae is associated with its
    corresponding trigram. *)
val compute : Movement.t list -> (t * Sexp.t) Or_error.t
