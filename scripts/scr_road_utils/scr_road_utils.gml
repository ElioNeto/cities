// Funções auxiliares para sistema de estradas

/// @function build_road_line(x1, y1, x2, y2, road_type)
/// @description Constrói estrada em linha reta entre dois pontos da grade
/// @param {real} x1 - Grid X inicial
/// @param {real} y1 - Grid Y inicial
/// @param {real} x2 - Grid X final
/// @param {real} y2 - Grid Y final
/// @param {real} road_type - Tipo de estrada (1=terra, 2=asfalto, 3=avenida)
function build_road_line(x1, y1, x2, y2, road_type) {
    // Usar algoritmo de linha de Bresenham para células entre os pontos
    var dx = abs(x2 - x1);
    var dy = abs(y2 - y1);
    var sx = (x1 < x2) ? 1 : -1;
    var sy = (y1 < y2) ? 1 : -1;
    var err = dx - dy;

    var current_x = x1;
    var current_y = y1;

    while (true) {
        // Tentar construir estrada na posição atual
        build_road_at(current_x, current_y, road_type);

        // Verificar se chegou ao destino
        if (current_x == x2 && current_y == y2) break;

        // Avançar para próxima célula
        var e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            current_x += sx;
        }
        if (e2 < dx) {
            err += dx;
            current_y += sy;
        }
    }
}

/// @function build_road_at(grid_x, grid_y, road_type)
/// @description Constrói uma estrada em uma célula específica
/// @param {real} grid_x - Coordenada X na grade
/// @param {real} grid_y - Coordenada Y na grade
/// @param {real} road_type - Tipo de estrada
/// @return {bool} True se construiu com sucesso
function build_road_at(grid_x, grid_y, road_type) {
    // Verificar se está dentro dos limites
    if (!in_bounds(grid_x, grid_y)) {
        return false;
    }

    // Obter tipo atual da célula
    var current_type = get_cell_type(grid_x, grid_y);

    // Se já tem estrada do mesmo tipo ou superior, não construir
    if (current_type >= 1 && current_type <= 3) {
        if (current_type >= road_type) {
            return false; // Já tem estrada igual ou melhor
        }
    }

    // Verificar se tem dinheiro
    var cost = global.road_cost[road_type];
    if (global.money < cost) {
        return false;
    }

    // Construir estrada
    set_cell_type(grid_x, grid_y, road_type);
    global.money -= cost;

    // Atualizar sprite da célula (será feito automaticamente no Draw do obj_cell)

    return true;
}

/// @function is_adjacent_to_road(grid_x, grid_y)
/// @description Verifica se uma célula é adjacente a uma estrada
/// @param {real} grid_x - Coordenada X na grade
/// @param {real} grid_y - Coordenada Y na grade
/// @return {bool}
function is_adjacent_to_road(grid_x, grid_y) {
    // Verificar 4 direções cardinais
    var directions = [
        [0, -1],  // Norte
        [1, 0],   // Leste
        [0, 1],   // Sul
        [-1, 0]   // Oeste
    ];

    for (var i = 0; i < array_length(directions); i++) {
        var check_x = grid_x + directions[i][0];
        var check_y = grid_y + directions[i][1];

        if (in_bounds(check_x, check_y)) {
            var cell_type = get_cell_type(check_x, check_y);
            if (cell_type >= 1 && cell_type <= 3) {
                return true; // É uma estrada
            }
        }
    }

    return false;
}

/// @function get_road_connections(grid_x, grid_y)
/// @description Retorna quais direções têm estradas conectadas (para auto-tiling)
/// @param {real} grid_x - Coordenada X na grade
/// @param {real} grid_y - Coordenada Y na grade
/// @return {array} [norte, leste, sul, oeste] - true/false para cada direção
function get_road_connections(grid_x, grid_y) {
    var connections = [false, false, false, false]; // N, E, S, W
    var directions = [[0, -1], [1, 0], [0, 1], [-1, 0]];

    for (var i = 0; i < 4; i++) {
        var check_x = grid_x + directions[i][0];
        var check_y = grid_y + directions[i][1];

        if (in_bounds(check_x, check_y)) {
            var cell_type = get_cell_type(check_x, check_y);
            if (cell_type >= 1 && cell_type <= 3) {
                connections[i] = true;
            }
        }
    }

    return connections;
}