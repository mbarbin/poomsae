open! Core

module Line_kind = struct
  type t =
    | Plain
    | Two_parts
  [@@deriving equal, compare, enumerate, hash, sexp_of]

  let to_string = function
    | Plain -> "------"
    | Two_parts -> "--  --"
  ;;
end

type t =
  { top_line : Line_kind.t
  ; middle_line : Line_kind.t
  ; bottom_line : Line_kind.t
  }
[@@deriving equal, compare, enumerate, hash, sexp_of]

let index t =
  let bit_value (line_kind : Line_kind.t) : int =
    match line_kind with
    | Plain -> 0
    | Two_parts -> 1
  in
  1 + bit_value t.top_line + (2 * bit_value t.middle_line) + (4 * bit_value t.bottom_line)
;;

let top_down_line_kinds { top_line; middle_line; bottom_line } =
  [ top_line; middle_line; bottom_line ]
;;

let top_down_lines t = t |> top_down_line_kinds |> List.map ~f:Line_kind.to_string

let compute_position_valuation (position : Position.Kind.t) =
  match position with
  | Ap_Seugui -> 1
  | Dwitt_Koubi -> 1
  | Ap_Koubi_Seugui -> 3
  | Wen_Seugui | Oren_Seugui -> 1
  | Dwitt_Koa -> 1
  | Naranhi_Seugui | Moa_Seugui -> 0
  | Beum_Seugui -> 1
;;

let compute movements =
  let module Lateral_displacement = struct
    type t =
      { mutable west : int
      ; mutable east : int
      }
    [@@deriving sexp_of]

    let zero () = { west = 0; east = 0 }

    let update t ~lateral_displacement =
      if lateral_displacement > 0
      then t.east <- max t.east lateral_displacement
      else t.west <- max t.west (-1 * lateral_displacement)
    ;;
  end
  in
  let lateral_displacements = Hashtbl.create (module Int) in
  let rec iter ~longitudinal_displacement ~lateral_displacement ~last_movement = function
    | [] -> ()
    | (movement : Movement.t) :: tl ->
      let position_valuation =
        compute_position_valuation (Position.kind movement.position)
      in
      (match movement.direction with
       | (West | East) as direction ->
         let lateral_displacement =
           let is_same_foot_and_direction =
             let open Option.Let_syntax in
             let%bind last_position =
               match last_movement with
               | None -> None
               | Some (last_movement : Movement.t) ->
                 if Direction.equal last_movement.direction direction
                 then return last_movement.position
                 else None
             in
             let new_foot = Position.front_foot movement.position in
             let last_foot = Position.front_foot last_position in
             if Option.equal Side.equal new_foot last_foot
             then return (compute_position_valuation (Position.kind last_position))
             else None
           in
           match direction with
           | West ->
             (match is_same_foot_and_direction with
              | None -> lateral_displacement - position_valuation
              | Some previous_valuation ->
                lateral_displacement + previous_valuation - position_valuation)
           | East ->
             (match is_same_foot_and_direction with
              | None -> lateral_displacement + position_valuation
              | Some previous_valuation ->
                lateral_displacement - previous_valuation + position_valuation)
           | North | South -> assert false
         in
         let existing_lateral_displacement =
           Hashtbl.find_or_add
             lateral_displacements
             longitudinal_displacement
             ~default:Lateral_displacement.zero
         in
         Lateral_displacement.update existing_lateral_displacement ~lateral_displacement;
         iter
           ~longitudinal_displacement
           ~lateral_displacement
           ~last_movement:(Some movement)
           tl
       | (North | South) as direction ->
         let longitudinal_displacement =
           match direction with
           | North -> longitudinal_displacement + position_valuation
           | South -> longitudinal_displacement - position_valuation
           | West | East -> assert false
         in
         iter
           ~longitudinal_displacement
           ~lateral_displacement
           ~last_movement:(Some movement)
           tl)
  in
  iter ~longitudinal_displacement:0 ~lateral_displacement:0 ~last_movement:None movements;
  let lateral_displacements =
    Hashtbl.to_alist lateral_displacements
    |> List.sort ~compare:(fun (d1, _) (d2, _) -> Int.compare d2 d1)
  in
  match
    let open Result.Let_syntax in
    match lateral_displacements |> List.map ~f:snd with
    | [ l1; l2; l3 ] as lateral_displacements ->
      let%bind (absolute_displacements : int list) =
        List.map lateral_displacements ~f:(fun t -> max t.west t.east)
        |> List.sort_and_group ~compare:Int.compare
        |> List.filter_map ~f:(function
          | [] -> None
          | hd :: _ -> Some hd)
        |> return
      in
      (match absolute_displacements with
       | [ _ ] -> return { top_line = Plain; middle_line = Plain; bottom_line = Plain }
       | [ small; _ ] | [ small; _; _ ] ->
         let line (l : Lateral_displacement.t) =
           if max l.west l.east = small then Line_kind.Two_parts else Line_kind.Plain
         in
         return { top_line = line l1; middle_line = line l2; bottom_line = line l3 }
       | _ -> Error ())
    | _ -> Error ()
  with
  | Ok t -> Ok (t, [%sexp { lateral_displacements : (int * Lateral_displacement.t) list }])
  | Error () ->
    Or_error.error_s
      [%sexp
        "Unexpected displacements"
        , { lateral_displacements : (int * Lateral_displacement.t) list }]
;;
