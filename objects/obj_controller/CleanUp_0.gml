/// obj_controller - Clean Up Event
// Destruir estruturas de dados ao fechar o jogo

if (ds_exists(global.map_grid, ds_type_grid)) {
    ds_grid_destroy(global.map_grid);
}

if (ds_exists(global.building_grid, ds_type_grid)) {
    ds_grid_destroy(global.building_grid);
}

show_debug_message("Grids destruídos com sucesso");