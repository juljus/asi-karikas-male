globalvar rook_moves, bishop_moves, knight_moves;
globalvar pawn_moves_white_attack, pawn_moves_white_move, pawn_moves_white_move_start;
globalvar pawn_moves_black_attack, pawn_moves_black_move, pawn_moves_black_move_start;
globalvar white_pawn_start, black_pawn_start;
globalvar white_pieces, black_pieces;

rook_moves = [[1, -1, 0], [0, -1, 1], [1, 0, -1], [0, 1, -1], [-1, 1, 0], [-1, 0, 1]];
bishop_moves = [[1, -2, 1], [2, -1, -1], [1, 1, -2], [-1, 2, -1], [-2, 1, 1], [-1, -1, 2]];
knight_moves = [[1, -3, 2], [2, -3, 1], [3, -2, -1], [3, -1, -2], [2, 1, -3], [1, 2, -3], [-1, 3, -2], [-2, 3, -1], [-3, 2, 1], [-3, 1, 2], [-2, -1, 3], [-1, -2, 3]];
pawn_moves_white_attack = [[1, -1, 0], [-1, 0, 1]];
pawn_moves_white_move = [[0, -1, 1]];
pawn_moves_white_move_start = [[0, -1, 1], [0, -2, 2]];
pawn_moves_black_attack = [[1, 0, -1], [-1, 1, 0]];
pawn_moves_black_move = [[0, 1, -1]];
pawn_moves_black_move_start = [[0, 1, -1], [0, 2, -2]];

white_pieces = [
    [[1, 4, -5]], // king
    [[-1, 5, -4]], // queen
    [[-3, 5, -2], [3, 2, -5]], // rooks
    [[0, 5, -5], [0, 4, -4], [0, 3, -3]], // bishops
    [[-2, 5, -3], [2, 3, -5]], // knights
    [[-4, 5, -1], [-3, 4, -1], [-2, 3, -1], [-1, 2, -1], [0, 1, -1], [1, 1, -2], [2, 1, -3], [3, 1, -4], [4, 1, -5]] // pawns
];

black_pieces = [
    [[1, -5, 4]], // king
    [[-1, -4, 5]], // queen
    [[-3, -2, 5], [3, -5, 2]], // rooks
    [[0, -5, 5], [0, -4, 4], [0, -3, 3]], // bishops
    [[-2, -3, 5], [2, -5, 3]], // knights
    [[-4, -1, 5], [-3, -1, 4], [-2, -1, 3], [-1, -1, 2], [0, -1, 1], [1, -2, 1], [2, -3, 1], [3, -4, 1], [4, -5, 1]] // pawns
];

white_pawn_start = [[-4, 5, -1], [-3, 4, -1], [-2, 3, -1], [-1, 2, -1], [0, 1, -1], [1, 1, -2], [2, 1, -3], [3, 1, -4], [4, 1, -5]];
black_pawn_start = [[-4, -1, 5], [-3, -1, 4], [-2, -1, 3], [-1, -1, 2], [0, -1, 1], [1, -2, 1], [2, -3, 1], [3, -4, 1], [4, -5, 1]];

function get_best_move(color) {
    // first update all the pieces, by looping through all objects of type ob_black_piece and ob_white_piece and updating the arrays
    white_pieces = [[], [], [], [], [], []];
    black_pieces = [[], [], [], [], [], []];

    with (ob_piece_white) {
        if (image_index == 0) {
            array_push(white_pieces[5], [ix, iy, iz]);
        } else if (image_index == 1) {
            array_push(white_pieces[4], [ix, iy, iz]);
        } else if (image_index == 2) {
            array_push(white_pieces[3], [ix, iy, iz]);
        } else if (image_index == 3) {
            array_push(white_pieces[2], [ix, iy, iz]);
        } else if (image_index == 4) {
            array_push(white_pieces[1], [ix, iy, iz]);
        } else if (image_index == 5) {
            array_push(white_pieces[0], [ix, iy, iz]);
        }
    }

    with (ob_piece_black) {
        if (image_index == 0) {
            array_push(black_pieces[5], [ix, iy, iz]);
        } else if (image_index == 1) {
            array_push(black_pieces[4], [ix, iy, iz]);
        } else if (image_index == 2) {
            array_push(black_pieces[3], [ix, iy, iz]);
        } else if (image_index == 3) {
            array_push(black_pieces[2], [ix, iy, iz]);
        } else if (image_index == 4) {
            array_push(black_pieces[1], [ix, iy, iz]);
        } else if (image_index == 5) {
            array_push(black_pieces[0], [ix, iy, iz]);
        }
    }


    var possible_moves = get_all_possible_moves(color);
    
    for (var i = 0; i < array_length(possible_moves); i++) {
        for (var j = 0; j < array_length(possible_moves[i]); j++) {
            if (!move_results_in_self_check(possible_moves[i][j])) {
                array_delete(possible_moves[i], j, 1);
                j--;
            }
        }
    }
    
    var temp_len = array_length(possible_moves);
    var one_piece_moves = possible_moves[irandom(temp_len - 1)];

    show_debug_message(evaluate_position(color, white_pieces, black_pieces));
	
	var sel_piece = irandom(array_length(one_piece_moves) - 1);
	
	var retval = [one_piece_moves[sel_piece][0], one_piece_moves[sel_piece][1]];
	
    return retval;
}

function evaluate_position(color, friendly_pieces, enemy_pieces) {
    var score_ = 0;
    var enemy_color = (color == "white") ? "black" : "white";
    
    for (var i = 0; i < array_length(friendly_pieces); i++) {
        for (var j = 0; j < array_length(friendly_pieces[i]); j++) {
            score_ += evaluate_piece(i, color, friendly_pieces[i][j]);
        }
    }
    
    for (var i = 0; i < array_length(enemy_pieces); i++) {
        for (var j = 0; j < array_length(enemy_pieces[i]); j++) {
            score_ -= evaluate_piece(i, enemy_color, enemy_pieces[i][j]);
        }
    }
    
    return score_;
}

function pawn_distance_from_start(color, coordinates) {
    if (color == "white") {
        for (var i = 0; i < array_length(white_pawn_start); i++) {
            if (white_pawn_start[i][0] == coordinates[0]) {
                return abs(white_pawn_start[i][1] - coordinates[1]);
            }
        }
    } else if (color == "black") {
        for (var i = 0; i < array_length(black_pawn_start); i++) {
            if (black_pawn_start[i][0] == coordinates[0]) {
                return abs(coordinates[1] - black_pawn_start[i][1]);
            }
        }
    }
    
    if (coordinates[0] == 5) {
        return (color == "white") ? abs(coordinates[1]) + 1 : 6 - abs(coordinates[1]);
    } else if (coordinates[0] == -5) {
        return (color == "white") ? 6 - abs(coordinates[1]) : abs(coordinates[1]) + 1;
    }
    
    return 0;
}

function is_end_game() {
    var pieces_at_start = 36;
    var total_pieces = 0;
    
    for (var i = 0; i < array_length(white_pieces); i++) {
        total_pieces += array_length(white_pieces[i]);
    }
    
    for (var i = 0; i < array_length(black_pieces); i++) {
        total_pieces += array_length(black_pieces[i]);
    }
    
    return total_pieces < 12;
}

function distance_from_center(coordinates) {
    return (abs(coordinates[0]) + abs(coordinates[1]) + abs(coordinates[2])) / 2;
}

function evaluate_piece(piece, color, coordinates) {
    var score_ = 0;
    
    if (piece == 5) {
        score_ += 1;
        var extra_points_per_square = 0.2;
        score_ += extra_points_per_square * pawn_distance_from_start(color, coordinates);
    } else if (piece == 4) {
        score_ += 3;
        var extra_points_per_square = 0.4;
        score_ += (5 - distance_from_center(coordinates)) * extra_points_per_square;
    } else if (piece == 3) {
        score_ += 3;
        var extra_points_per_square = 0.4;
        score_ += (5 - distance_from_center(coordinates)) * extra_points_per_square;
    } else if (piece == 2) {
        score_ += 5;
        var extra_points_per_square = 0.6;
        score_ += (5 - distance_from_center(coordinates)) * extra_points_per_square;
    } else if (piece == 1) {
        score_ += 9;
        var extra_points_per_square = 0.8;
        score_ += (5 - distance_from_center(coordinates)) * extra_points_per_square;
    } else if (piece == 0) {
        score_ += 99;
        if (is_end_game()) {
            var extra_points_per_square = 0.2;
            score_ += (5 - distance_from_center(coordinates)) * extra_points_per_square;
        } else {
            var extra_points_per_square = 0.2;
            if (color == "white") {
                score_ += (5 + coordinates[1]) * extra_points_per_square;
            } else if (color == "black") {
                score_ += (5 - coordinates[1]) * extra_points_per_square;
            }
        }
    }
    
    return score_;
}

function get_all_possible_moves(color) {
    var possible_moves = [];
    
    if (color == "white") {
        for (var i = 0; i < array_length(white_pieces); i++) {
            for (var j = 0; j < array_length(white_pieces[i]); j++) {
                array_push(possible_moves, get_piece_moves(i, "white", white_pieces[i][j]));
            }
        }
    } else if (color == "black") {
        for (var i = 0; i < array_length(black_pieces); i++) {
            for (var j = 0; j < array_length(black_pieces[i]); j++) {
                array_push(possible_moves, get_piece_moves(i, "black", black_pieces[i][j]));
            }
        }
    }
    
    return possible_moves;
}

function move_results_in_self_check(move) {
    var start_cords = move[0];
    var end_cords = move[1];
    var tar_piece = move[2];
	
    var start_piece_and_color = get_square_piece(start_cords);
    var start_piece = start_piece_and_color[0];
    var color = start_piece_and_color[1];
    
    var temp_white_pieces = copy_array(white_pieces);
    var temp_black_pieces = copy_array(black_pieces);
    
    if (color == "white") {
        for (var i = 0; i < array_length(temp_white_pieces); i++) {
            for (var j = 0; j < array_length(temp_white_pieces[i]); j++) {
                if (temp_white_pieces[i][j] == start_cords) {
                    temp_white_pieces[i][j] = end_cords;
                    break;
                }
            }
        }
    } else if (color == "black") {
        for (var i = 0; i < array_length(temp_black_pieces); i++) {
            for (var j = 0; j < array_length(temp_black_pieces[i]); j++) {
                if (temp_black_pieces[i][j] == start_cords) {
                    temp_black_pieces[i][j] = end_cords;
                    break;
                }
            }
        }
    } else {
        return false;
    }
    
    if (is_checked(color)) {
        return false;
    }
    
    return true;
}

function copy_array(arr) {
    var new_arr = [];
    for (var i = 0; i < array_length(arr); i++) {
        array_push(new_arr, arr[i]);
    }
    return new_arr;
}

function get_piece_moves(piece, color, coordinates) {
    var ret_list = [];
    
    if (piece == 2) {
        for (var i = 0; i < array_length(rook_moves); i++) {
            var test_c = copy_array(coordinates);
            while (true) {
                test_c[0] += rook_moves[i][0];
                test_c[1] += rook_moves[i][1];
                test_c[2] += rook_moves[i][2];

                var tar_piece_and_color = get_square_piece(test_c);
                var tar_piece = tar_piece_and_color[0];
                var tar_color = tar_piece_and_color[1];

                if (!valid_square(test_c)) break;
                if (tar_color == color) break;
                if (tar_color != undefined) {
                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                    break;
                }

                array_push(ret_list, [coordinates, test_c, tar_piece]);
            }
        }
    } else if (piece == 3) {
        for (var i = 0; i < array_length(bishop_moves); i++) {
            var test_c = copy_array(coordinates);
            while (true) {
                test_c[0] += bishop_moves[i][0];
                test_c[1] += bishop_moves[i][1];
                test_c[2] += bishop_moves[i][2];

                var tar_piece_and_color = get_square_piece(test_c);
                var tar_piece = tar_piece_and_color[0];
                var tar_color = tar_piece_and_color[1];

                if (!valid_square(test_c)) break;
                if (tar_color == color) break;
                if (tar_color != undefined) {
                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                    break;
                }

                array_push(ret_list, [coordinates, test_c, tar_piece]);
            }
        }
    } else if (piece == 4) {
        for (var i = 0; i < array_length(knight_moves); i++) {
            var test_c = copy_array(coordinates);
            test_c[0] += knight_moves[i][0];
            test_c[1] += knight_moves[i][1];
            test_c[2] += knight_moves[i][2];

            var tar_piece_and_color = get_square_piece(test_c);
            var tar_piece = tar_piece_and_color[0];
            var tar_color = tar_piece_and_color[1];

            if (!valid_square(test_c)) continue;
            if (tar_color == color) continue;
            if (tar_color != undefined) {
                array_push(ret_list, [coordinates, test_c, tar_piece]);
                continue;
            }

            array_push(ret_list, [coordinates, test_c, tar_piece]);
        }
    } else if (piece == 1) {
        for (var i = 0; i < array_length(rook_moves); i++) {
            var test_c = copy_array(coordinates);
            while (true) {
                test_c[0] += rook_moves[i][0];
                test_c[1] += rook_moves[i][1];
                test_c[2] += rook_moves[i][2];

                var tar_piece_and_color = get_square_piece(test_c);
                var tar_piece = tar_piece_and_color[0];
                var tar_color = tar_piece_and_color[1];

                if (!valid_square(test_c)) break;
                if (tar_color == color) break;
                if (tar_color != undefined) {
                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                    break;
                }

                array_push(ret_list, [coordinates, test_c, tar_piece]);
            }
        }
        
        for (var i = 0; i < array_length(bishop_moves); i++) {
            var test_c = copy_array(coordinates);
            while (true) {
                test_c[0] += bishop_moves[i][0];
                test_c[1] += bishop_moves[i][1];
                test_c[2] += bishop_moves[i][2];

                var tar_piece_and_color = get_square_piece(test_c);
                var tar_piece = tar_piece_and_color[0];
                var tar_color = tar_piece_and_color[1];

                if (!valid_square(test_c)) break;
                if (tar_color == color) break;
                if (tar_color != undefined) {
                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                    break;
                }

                array_push(ret_list, [coordinates, test_c, tar_piece]);
            }
        }
    } else if (piece == 0) {
        for (var i = 0; i < array_length(rook_moves); i++) {
            var test_c = copy_array(coordinates);
            test_c[0] += rook_moves[i][0];
            test_c[1] += rook_moves[i][1];
            test_c[2] += rook_moves[i][2];

            var tar_piece_and_color = get_square_piece(test_c);
            var tar_piece = tar_piece_and_color[0];
            var tar_color = tar_piece_and_color[1];

            if (!valid_square(test_c)) continue;
            if (tar_color == color) continue;
            if (tar_color != undefined) {
                array_push(ret_list, [coordinates, test_c, tar_piece]);
                continue;
            }

            array_push(ret_list, [coordinates, test_c, tar_piece]);
        }
        
        for (var i = 0; i < array_length(bishop_moves); i++) {
            var test_c = copy_array(coordinates);
            test_c[0] += bishop_moves[i][0];
            test_c[1] += bishop_moves[i][1];
            test_c[2] += bishop_moves[i][2];

            var tar_piece_and_color = get_square_piece(test_c);
            var tar_piece = tar_piece_and_color[0];
            var tar_color = tar_piece_and_color[1];

            if (!valid_square(test_c)) continue;
            if (tar_color == color) continue;
            if (tar_color != undefined) {
                array_push(ret_list, [coordinates, test_c, tar_piece]);
                continue;
            }

            array_push(ret_list, [coordinates, test_c, tar_piece]);
        }
    } else if (piece == 5) {
        var is_on_starting_square = pawn_on_starting_square(color, coordinates);
        
        if (color == "white") {
            for (var i = 0; i < array_length(pawn_moves_white_attack); i++) {
                var test_c = copy_array(coordinates);
                test_c[0] += pawn_moves_white_attack[i][0];
                test_c[1] += pawn_moves_white_attack[i][1];
                test_c[2] += pawn_moves_white_attack[i][2];

                var tar_piece_and_color = get_square_piece(test_c);
                var tar_piece = tar_piece_and_color[0];
                var tar_color = tar_piece_and_color[1];

                if (!valid_square(test_c)) continue;
                if (tar_color == color) continue;
                if (tar_color != undefined) {
                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                    continue;
                }
            }
            
            if (is_on_starting_square) {
                for (var i = 0; i < array_length(pawn_moves_white_move_start); i++) {
                    var test_c = copy_array(coordinates);
                    test_c[0] += pawn_moves_white_move_start[i][0];
                    test_c[1] += pawn_moves_white_move_start[i][1];
                    test_c[2] += pawn_moves_white_move_start[i][2];

                    var tar_piece_and_color = get_square_piece(test_c);
                    var tar_piece = tar_piece_and_color[0];
                    var tar_color = tar_piece_and_color[1];

                    if (!valid_square(test_c)) continue;
                    if (tar_color == color) continue;
                    if (tar_color != undefined) continue;

                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                }
            } else {
                for (var i = 0; i < array_length(pawn_moves_white_move); i++) {
                    var test_c = copy_array(coordinates);
                    test_c[0] += pawn_moves_white_move[i][0];
                    test_c[1] += pawn_moves_white_move[i][1];
                    test_c[2] += pawn_moves_white_move[i][2];

                    var tar_piece_and_color = get_square_piece(test_c);
                    var tar_piece = tar_piece_and_color[0];
                    var tar_color = tar_piece_and_color[1];

                    if (!valid_square(test_c)) continue;
                    if (tar_color == color) continue;
                    if (tar_color != undefined) continue;

                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                }
            }
        } else if (color == "black") {
            for (var i = 0; i < array_length(pawn_moves_black_attack); i++) {
                var test_c = copy_array(coordinates);
                test_c[0] += pawn_moves_black_attack[i][0];
                test_c[1] += pawn_moves_black_attack[i][1];
                test_c[2] += pawn_moves_black_attack[i][2];

                var tar_piece_and_color = get_square_piece(test_c);
                var tar_piece = tar_piece_and_color[0];
                var tar_color = tar_piece_and_color[1];

                if (!valid_square(test_c)) continue;
                if (tar_color == color) continue;
                if (tar_color != undefined) {
                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                    continue;
                }
            }
            
            if (is_on_starting_square) {
                for (var i = 0; i < array_length(pawn_moves_black_move_start); i++) {
                    var test_c = copy_array(coordinates);
                    test_c[0] += pawn_moves_black_move_start[i][0];
                    test_c[1] += pawn_moves_black_move_start[i][1];
                    test_c[2] += pawn_moves_black_move_start[i][2];

                    var tar_piece_and_color = get_square_piece(test_c);
                    var tar_piece = tar_piece_and_color[0];
                    var tar_color = tar_piece_and_color[1];

                    if (!valid_square(test_c)) continue;
                    if (tar_color == color) continue;
                    if (tar_color != undefined) continue;

                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                }
            } else {
                for (var i = 0; i < array_length(pawn_moves_black_move); i++) {
                    var test_c = copy_array(coordinates);
                    test_c[0] += pawn_moves_black_move[i][0];
                    test_c[1] += pawn_moves_black_move[i][1];
                    test_c[2] += pawn_moves_black_move[i][2];

                    var tar_piece_and_color = get_square_piece(test_c);
                    var tar_piece = tar_piece_and_color[0];
                    var tar_color = tar_piece_and_color[1];

                    if (!valid_square(test_c)) continue;
                    if (tar_color == color) continue;
                    if (tar_color != undefined) continue;

                    array_push(ret_list, [coordinates, test_c, tar_piece]);
                }
            }
        }
    }
    
    return ret_list;
}

function pawn_on_starting_square(color, coordinates) {
    if (color == "white") {
        for (var i = 0; i < array_length(white_pawn_start); i++) {
            var start = white_pawn_start[i];
            if (start[0] == coordinates[0] && start[1] == coordinates[1] && start[2] == coordinates[2]) {
                return true;
            }
        }
    } else if (color == "black") {
        for (var i = 0; i < array_length(black_pawn_start); i++) {
            var start = black_pawn_start[i];
            if (start[0] == coordinates[0] && start[1] == coordinates[1] && start[2] == coordinates[2]) {
                return true;
            }
        }
    }
    
    return false;
}

function get_square_piece(coordinates) {
    for (var i = 0; i < array_length(white_pieces); i++) {
        var coordinates_array = white_pieces[i];
        for (var j = 0; j < array_length(coordinates_array); j++) {
            if (coordinates_array[j] == coordinates) {
                return [i, "white"];
            }
        }
    }
    
    for (var i = 0; i < array_length(black_pieces); i++) {
        var coordinates_array = black_pieces[i];
        for (var j = 0; j < array_length(coordinates_array); j++) {
            if (coordinates_array[j] == coordinates) {
                return [i, "black"];
            }
        }
    }
    
    return [undefined, undefined];
}

function valid_square(coordinates) {
    var x_ = coordinates[0];
    var y_ = coordinates[1];
    var z_ = coordinates[2];
    
    return (x_ >= -5 && x_ <= 5 && y_ >= -5 && y_ <= 5 && z_ >= -5 && z_ <= 5 && x_ + y_ + z_ == 0);
}

function is_checked(color) {
    var king_coordinates;
    
    if (color == "white") {
        king_coordinates = white_pieces[0][0];
    } else if (color == "black") {
        king_coordinates = black_pieces[0][0];
    }
    
    var enemy_color = (color == "white") ? "black" : "white";
    var enemy_moves = get_all_possible_moves(enemy_color);
    
    for (var i = 0; i < array_length(enemy_moves); i++) {
        for (var j = 0; j < array_length(enemy_moves[i]); j++) {
            if (enemy_moves[i][j][1] == king_coordinates) {
                return true;
            }
        }
    }
	
    
    return false;
}
