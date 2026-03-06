/// obj_grid_manager - Create Event
// Gerenciador responsável por criar objetos obj_cell para visualização

// Criar células visuais para todo o mapa
for (var i = 0; i < global.map_width; i++) {
    for (var j = 0; j < global.map_height; j++) {
        var cell = instance_create_layer(
            i * global.cell_size,
            j * global.cell_size,
            "Tiles",
            obj_cell
        );
        cell.grid_x = i;
        cell.grid_y = j;
    }
}

show_debug_message("Células visuais criadas: " + string(global.map_width * global.map_height));