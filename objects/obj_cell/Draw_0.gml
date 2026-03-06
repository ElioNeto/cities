// Obter tipo atual da célula no grid
cell_type = get_cell_type(grid_x, grid_y);

// Desenhar baseado no tipo
switch(cell_type) {
    case 0: // Vazio
        draw_sprite(spr_ground_empty, 0, x, y);
        break;

    case 1: // Estrada de terra
        draw_sprite(spr_road_dirt, 0, x, y);
        break;

    case 2: // Asfalto
        draw_sprite(spr_road_asphalt, 0, x, y);
        break;

    case 3: // Avenida
        draw_sprite(spr_road_avenue, 0, x, y);
        break;

    default:
        // Tipo desconhecido, desenhar vermelho
        draw_set_color(c_red);
        draw_rectangle(x, y, x + global.cell_size, y + global.cell_size, false);
        break;
}

// Debug: desenhar borda da célula
draw_set_color(c_dkgray);
draw_set_alpha(0.2);
draw_rectangle(x, y, x + global.cell_size, y + global.cell_size, true);
draw_set_alpha(1.0);

// Preview de construção (mostrar onde vai construir)
if (global.tool_mode == 1) {
    var mouse_pos = get_mouse_grid_pos();
    if (mouse_pos[0] == grid_x && mouse_pos[1] == grid_y) {
        // Desenhar preview semi-transparente
        draw_set_alpha(0.5);
        switch(global.road_type) {
            case 1: draw_sprite(spr_road_dirt, 0, x, y); break;
            case 2: draw_sprite(spr_road_asphalt, 0, x, y); break;
            case 3: draw_sprite(spr_road_avenue, 0, x, y); break;
        }
        draw_set_alpha(1.0);
    }
}

draw_set_color(c_white);