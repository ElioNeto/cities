/// scr_grid_utils
// Funções auxiliares para manipulação da grade

/// @function in_bounds(grid_x, grid_y)
/// @description Verifica se coordenadas estão dentro dos limites da grade
/// @param {real} grid_x - Coordenada X na grade
/// @param {real} grid_y - Coordenada Y na grade
/// @return {bool}
function in_bounds(grid_x, grid_y) {
    return (grid_x >= 0 && grid_x < global.map_width && 
            grid_y >= 0 && grid_y < global.map_height);
}

/// @function world_to_grid(world_x, world_y)
/// @description Converte coordenadas do mundo (pixels) para coordenadas da grade
/// @param {real} world_x - Coordenada X em pixels
/// @param {real} world_y - Coordenada Y em pixels
/// @return {array} [grid_x, grid_y]
function world_to_grid(world_x, world_y) {
    var grid_x = floor(world_x / global.cell_size);
    var grid_y = floor(world_y / global.cell_size);
    return [grid_x, grid_y];
}

/// @function grid_to_world(grid_x, grid_y)
/// @description Converte coordenadas da grade para coordenadas do mundo (pixels)
/// @param {real} grid_x - Coordenada X na grade
/// @param {real} grid_y - Coordenada Y na grade
/// @return {array} [world_x, world_y]
function grid_to_world(grid_x, grid_y) {
    var world_x = grid_x * global.cell_size;
    var world_y = grid_y * global.cell_size;
    return [world_x, world_y];
}

/// @function get_cell_type(grid_x, grid_y)
/// @description Retorna o tipo de célula nas coordenadas especificadas
/// @param {real} grid_x - Coordenada X na grade
/// @param {real} grid_y - Coordenada Y na grade
/// @return {real} Tipo da célula (0=vazio, 1+=outros tipos)
function get_cell_type(grid_x, grid_y) {
    if (!in_bounds(grid_x, grid_y)) {
        return -1; // Fora dos limites
    }
    return ds_grid_get(global.map_grid, grid_x, grid_y);
}

/// @function set_cell_type(grid_x, grid_y, cell_type)
/// @description Define o tipo de célula nas coordenadas especificadas
/// @param {real} grid_x - Coordenada X na grade
/// @param {real} grid_y - Coordenada Y na grade
/// @param {real} cell_type - Novo tipo da célula
/// @return {bool} True se bem-sucedido
function set_cell_type(grid_x, grid_y, cell_type) {
    if (!in_bounds(grid_x, grid_y)) {
        return false;
    }
    ds_grid_set(global.map_grid, grid_x, grid_y, cell_type);
    return true;
}

/// @function get_mouse_grid_pos()
/// @description Retorna a posição da grade sob o cursor do mouse
/// @return {array} [grid_x, grid_y]
function get_mouse_grid_pos() {
    return world_to_grid(mouse_x, mouse_y);
}