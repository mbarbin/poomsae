open! Core

module Linear_displacement = struct
  (* So far we didn't need to rely on a relationship between the
     linear displacement of different positions. This may change as we
     add more poomsaes - to be determined. *)
  type t =
    { ap_seugui : int
    ; ap_koubi_seugui : int
    ; dwitt_koubi : int
    ; wen_or_oren_seugui : int
    ; dwitt_koa : int
    ; beum_seugui : int
    }
  [@@deriving equal, sexp_of]

  let zero =
    { ap_seugui = 0
    ; ap_koubi_seugui = 0
    ; dwitt_koubi = 0
    ; wen_or_oren_seugui = 0
    ; dwitt_koa = 0
    ; beum_seugui = 0
    }
  ;;

  let add t1 t2 =
    { ap_seugui = t1.ap_seugui + t2.ap_seugui
    ; ap_koubi_seugui = t1.ap_koubi_seugui + t2.ap_koubi_seugui
    ; dwitt_koubi = t1.dwitt_koubi + t2.dwitt_koubi
    ; wen_or_oren_seugui = t1.wen_or_oren_seugui + t2.wen_or_oren_seugui
    ; dwitt_koa = t1.dwitt_koa + t2.dwitt_koa
    ; beum_seugui = t1.beum_seugui + t2.beum_seugui
    }
  ;;

  let remove t1 t2 =
    { ap_seugui = t1.ap_seugui - t2.ap_seugui
    ; ap_koubi_seugui = t1.ap_koubi_seugui - t2.ap_koubi_seugui
    ; dwitt_koubi = t1.dwitt_koubi - t2.dwitt_koubi
    ; wen_or_oren_seugui = t1.wen_or_oren_seugui - t2.wen_or_oren_seugui
    ; dwitt_koa = t1.dwitt_koa - t2.dwitt_koa
    ; beum_seugui = t1.beum_seugui - t2.beum_seugui
    }
  ;;

  let of_position : Position.t -> t = function
    | Ap_Seugui { front_foot = Left | Right } -> { zero with ap_seugui = 1 }
    | Ap_Koubi_Seugui { front_foot = Left | Right } -> { zero with ap_koubi_seugui = 1 }
    | Dwitt_Koubi { front_foot = Left | Right } -> { zero with dwitt_koubi = 1 }
    | Wen_Seugui | Oren_Seugui -> { zero with wen_or_oren_seugui = 1 }
    | Dwitt_Koa { front_foot = Left | Right } -> { zero with dwitt_koa = 1 }
    | Naranhi_Seugui | Moa_Seugui -> zero
    | Beum_Seugui { front_foot = Left | Right } -> { zero with beum_seugui = 1 }
  ;;

  let add_position t (position : Position.t) = add t (of_position position)
end

type t = Linear_displacement.t Direction_diamond.t [@@deriving sexp_of]

let origin = Direction_diamond.return Linear_displacement.zero

let move t (movement : Movement.t) =
  Direction_diamond.map_direction t ~f:(fun direction linear_displacement ->
    if Direction.equal direction movement.direction
    then Linear_displacement.add_position linear_displacement movement.position
    else linear_displacement)
;;

module Two_dimensions = struct
  type t =
    { north : Linear_displacement.t
    ; west : Linear_displacement.t
    }
  [@@deriving equal, sexp_of]
end

let two_dimensions (t : t) =
  { Two_dimensions.north = Linear_displacement.remove t.north t.south
  ; west = Linear_displacement.remove t.west t.east
  }
;;

let equal t1 t2 = Two_dimensions.equal (two_dimensions t1) (two_dimensions t2)
